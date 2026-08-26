class Item < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :categories
  has_many :item_metadata, dependent: :destroy
  has_one_attached :image

  validates :name, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :low_stock_threshold, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :out_of_stock, -> { where(quantity: 0) }
  scope :low_stock, -> { where("quantity > 0 AND quantity <= low_stock_threshold") }
  scope :in_stock, -> { where("quantity > 0 AND (low_stock_threshold IS NULL OR quantity > low_stock_threshold)") }
  scope :needs_restocking, -> { where("quantity = 0 OR (quantity <= low_stock_threshold AND low_stock_threshold IS NOT NULL)") }

  scope :by_categories, ->(category_ids, match_all: false) {
    return all if category_ids.blank?

    if match_all
      item_ids = joins(:categories)
                  .where(categories: { id: category_ids })
                  .group("items.id")
                  .having("COUNT(DISTINCT categories.id) = ?", category_ids.length)
                  .pluck(:id)
      where(id: item_ids)
    else
      joins(:categories).where(categories: { id: category_ids }).distinct
    end
  }

  scope :by_type, ->(item_type) { item_type.present? ? where(item_type: item_type) : all }

  scope :by_stock_status, ->(status) {
    case status
    when "out_of_stock" then out_of_stock
    when "low_stock" then low_stock
    when "in_stock" then in_stock
    else all
    end
  }

  scope :search, ->(query) { query.present? ? where("items.name LIKE ? ESCAPE '\\'", "%#{sanitize_sql_like(query)}%") : all }

  ITEM_TYPES = [ "Alcohol", "Liqueur", "Juice", "Syrup", "Ingredient", "Other" ].freeze
  MAX_QUANTITY_ADJUSTMENT = 999
  MAX_QUANTITY = 9999

  validates :item_type, inclusion: { in: ITEM_TYPES }

  after_save :sync_pending_categories

  def metadata_hash
    item_metadata.pluck(:key, :value).to_h
  end

  def update_metadata(attributes)
    entries = {}
    attributes.each { |key, value| entries[key.to_s] = value if value.present? }

    transaction do
      item_metadata.where.not(key: entries.keys).delete_all

      if entries.any?
        now = Time.current
        rows = entries.map { |key, value| { item_id: id, key: key, value: value, created_at: now, updated_at: now } }
        ItemMetadatum.upsert_all(rows, unique_by: [ :item_id, :key ], update_only: [ :value, :updated_at ])
      end
    end

    item_metadata.reset
  end

  def increment_quantity!(amount = 1)
    adjust_quantity!(clamp_adjustment(amount))
  end

  def decrement_quantity!(amount = 1)
    adjust_quantity!(-clamp_adjustment(amount))
  end

  def set_quantity!(value)
    update!(quantity: value.to_i.clamp(0, MAX_QUANTITY))
  end

  def out_of_stock?
    quantity == 0
  end

  def low_stock?
    low_stock_threshold.present? && quantity > 0 && quantity <= low_stock_threshold
  end

  def needs_restocking?
    out_of_stock? || low_stock?
  end

  def category_names
    return @pending_category_names.join(", ") if @pending_category_names

    categories.map(&:name).join(", ")
  end

  def category_names=(value)
    @pending_category_names = value.to_s.split(",").map(&:strip).reject(&:blank?).uniq
  end

  private

  def sync_pending_categories
    return if @pending_category_names.nil?

    self.categories = @pending_category_names.map { |name| Category.find_or_create_by_name(name) }
    @pending_category_names = nil
  end

  def clamp_adjustment(amount)
    amount.to_i.clamp(1, MAX_QUANTITY_ADJUSTMENT)
  end

  def adjust_quantity!(delta)
    self.class.where(id: id).update_all([
      "quantity = MAX(0, quantity + ?), updated_at = ?", delta, Time.current
    ])
    reload
  end
end
