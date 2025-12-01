# typed: true

class Category < ApplicationRecord
  extend T::Sig

  has_and_belongs_to_many :items

  validates :name, presence: true, uniqueness: true

  before_validation :generate_slug

  private

  sig { returns(String) }
  def generate_slug
    self.slug = name.parameterize if name.present?
  end
end
