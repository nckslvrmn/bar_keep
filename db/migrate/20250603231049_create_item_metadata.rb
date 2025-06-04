class CreateItemMetadata < ActiveRecord::Migration[8.0]
  def change
    create_table :item_metadata do |t|
      t.references :item, null: false, foreign_key: true
      t.string :key
      t.text :value

      t.timestamps
    end
  end
end
