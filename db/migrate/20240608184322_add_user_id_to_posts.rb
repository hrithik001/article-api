class AddUserIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :user_id, :integer, default: 1, null: false # Assuming '1' is an existing valid user_id
    add_index :posts, :user_id
    add_foreign_key :posts, :users
  end
end
