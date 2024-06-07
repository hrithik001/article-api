class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :post_title
      t.string :post_content

      t.timestamps
    end
  end
end
