class AddGuestFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :is_guest, :boolean, default: false, null: false
    add_index :users, :is_guest
  end
end
