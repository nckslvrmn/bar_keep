class AddUserIdToItems < ActiveRecord::Migration[8.0]
  def change
    # First add the column without the not null constraint
    add_reference :items, :user, foreign_key: true

    # Assign all existing items to the first user (admin)
    reversible do |dir|
      dir.up do
        if User.any? && Item.any?
          Item.update_all(user_id: User.first.id)
        end
      end
    end

    # Now add the not null constraint
    change_column_null :items, :user_id, false
  end
end
