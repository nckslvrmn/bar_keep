class RemoveCategoryIdFromItems < ActiveRecord::Migration[8.0]
  def change
    remove_reference :items, :category, null: false, foreign_key: true
  end
end
