# typed: true

class ItemMetadatum < ApplicationRecord
  extend T::Sig

  belongs_to :item
end
