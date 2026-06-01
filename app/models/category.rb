class Category < ApplicationRecord
  has_and_belongs_to_many :items

  validates :name, presence: true, uniqueness: true

  before_validation :generate_slug

  # Remove categories that are no longer attached to any item, so the filter
  # UI doesn't accumulate stale entries as items are re-categorized or deleted.
  def self.delete_orphaned
    left_joins(:items).where(items: { id: nil }).destroy_all
  end

  private

  def generate_slug
    self.slug = name.parameterize if name.present?
  end
end
