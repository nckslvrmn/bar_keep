class ItemMetadatum < ApplicationRecord
  belongs_to :item

  validates :key, presence: true, uniqueness: { scope: :item_id }
end
