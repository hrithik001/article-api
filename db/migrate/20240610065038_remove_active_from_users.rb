class RemoveActiveFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :active, :boolean
  end
end
