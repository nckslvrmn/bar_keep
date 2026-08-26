class Category < ApplicationRecord
  has_and_belongs_to_many :items

  validates :name, presence: true, uniqueness: true

  before_validation :generate_slug

  # Remove categories that are no longer attached to any item, so the filter
  # UI doesn't accumulate stale entries as items are re-categorized or deleted.
  def self.delete_orphaned
    left_joins(:items).where(items: { id: nil }).destroy_all
  end

  def self.find_or_create_by_name(name)
    create_with(slug: name.parameterize).find_or_create_by!(name: name)
  rescue ActiveRecord::RecordNotUnique
    find_by!(name: name)
  end

  private

  def generate_slug
    self.slug = name.parameterize if name.present?
  end
end
