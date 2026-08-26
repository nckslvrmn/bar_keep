class Category < ApplicationRecord
  has_and_belongs_to_many :items

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  before_validation :generate_slug

  # Remove categories that are no longer attached to any item, so the filter
  # UI doesn't accumulate stale entries as items are re-categorized or deleted.
  def self.delete_orphaned
    left_joins(:items).where(items: { id: nil }).destroy_all
  end

  def self.find_or_create_by_name(name)
    slug = slug_for(name)
    find_by(slug: slug) || create!(name: name.strip, slug: slug)
  rescue ActiveRecord::RecordNotUnique
    find_by!(slug: slug)
  end

  def self.slug_for(name)
    name.parameterize.presence || name.strip.downcase
  end

  private

  def generate_slug
    self.slug = self.class.slug_for(name) if name.present?
  end
end
