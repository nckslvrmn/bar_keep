class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :session_token
      t.datetime :expires_at

      t.timestamps
    end
    add_index :sessions, :session_token, unique: true
  end
end
