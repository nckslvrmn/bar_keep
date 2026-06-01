class AddNotNullAndCategoryUniqueness < ActiveRecord::Migration[8.1]
  def change
    # Enforce at the database level what the models already validate.
    change_column_null :items, :name, false
    change_column_default :items, :quantity, from: nil, to: 0
    change_column_null :items, :quantity, false, 0
    change_column_null :items, :item_type, false

    change_column_null :categories, :name, false
    add_index :categories, :name, unique: true
    add_index :categories, :slug, unique: true
  end
end
