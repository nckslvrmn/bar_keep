class AddMissingIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :categories_items, [ :item_id, :category_id ], unique: true
    add_index :categories_items, :category_id

    add_index :item_metadata, [ :item_id, :key ], unique: true
  end
end
