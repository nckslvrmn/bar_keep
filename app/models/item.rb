class Item < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :item_metadata, dependent: :destroy
  has_one_attached :image

  validates :name, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :low_stock_threshold, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Scopes
  scope :out_of_stock, -> { where(quantity: 0) }
  scope :low_stock, -> { where("quantity > 0 AND quantity <= low_stock_threshold") }
  scope :in_stock, -> { where("quantity > 0 AND (low_stock_threshold IS NULL OR quantity > low_stock_threshold)") }
  scope :needs_restocking, -> { where("quantity = 0 OR (quantity <= low_stock_threshold AND low_stock_threshold IS NOT NULL)") }

  # Item types
  ITEM_TYPES = [ "Alcohol", "Liqueur", "Juice", "Syrup", "Ingredient", "Other" ].freeze

  validates :item_type, inclusion: { in: ITEM_TYPES }

  def metadata_hash
    item_metadata.pluck(:key, :value).to_h
  end

  def update_metadata(metadata_hash)
    transaction do
      # Remove existing metadata
      item_metadata.destroy_all

      # Add new metadata
      metadata_hash.each do |key, value|
        item_metadata.create!(key: key, value: value) if value.present?
      end
    end
  end

  def increment_quantity!(amount = 1)
    update!(quantity: quantity + amount)
  end

  def decrement_quantity!(amount = 1)
    update!(quantity: [ quantity - amount, 0 ].max)
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
    categories.pluck(:name).join(", ")
  end
end
