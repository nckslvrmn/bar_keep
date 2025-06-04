class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :quantity
      t.references :category, null: false, foreign_key: true
      t.integer :low_stock_threshold
      t.string :item_type

      t.timestamps
    end
  end
end
