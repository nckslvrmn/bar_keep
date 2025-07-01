class AddIsAdminToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :is_admin, :boolean, default: false, null: false

    # Make the first user (if exists) an admin
    reversible do |dir|
      dir.up do
        User.first&.update_column(:is_admin, true)
      end
    end
  end
end
