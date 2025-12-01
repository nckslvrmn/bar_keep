# typed: true

class Item < ApplicationRecord
  extend T::Sig
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

  scope :search, ->(query) { query.present? ? where("items.name LIKE ?", "%#{query}%") : all }

  ITEM_TYPES = [ "Alcohol", "Liqueur", "Juice", "Syrup", "Ingredient", "Other" ].freeze

  validates :item_type, inclusion: { in: ITEM_TYPES }

  sig { returns(T::Hash[String, String]) }
  def metadata_hash
    item_metadata.pluck(:key, :value).to_h
  end

  sig { params(metadata_hash: T::Hash[String, String]).void }
  def update_metadata(metadata_hash)
    transaction do
      item_metadata.destroy_all

      metadata_hash.each do |key, value|
        item_metadata.create!(key: key, value: value) if value.present?
      end
    end
  end

  sig { params(amount: Integer).void }
  def increment_quantity!(amount = 1)
    update!(quantity: quantity + amount)
  end

  sig { params(amount: Integer).void }
  def decrement_quantity!(amount = 1)
    update!(quantity: [ quantity - amount, 0 ].max)
  end

  sig { returns(T::Boolean) }
  def out_of_stock?
    quantity == 0
  end

  sig { returns(T::Boolean) }
  def low_stock?
    low_stock_threshold.present? && quantity > 0 && quantity <= low_stock_threshold
  end

  sig { returns(T::Boolean) }
  def needs_restocking?
    out_of_stock? || low_stock?
  end

  sig { returns(String) }
  def category_names
    categories.pluck(:name).join(", ")
  end
end
