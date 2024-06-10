class CreateJwtBlacklists < ActiveRecord::Migration[7.1]
  def change
    create_table :jwt_blacklists do |t|
      t.string :token
      t.timestamps
    end
  end
end
