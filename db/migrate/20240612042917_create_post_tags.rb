class CreatePostTags < ActiveRecord::Migration[7.1]
  def change
    create_table :posts_tags, id: false do |t|
      t.integer :post_id, null: false
      t.integer :tag_id, null: false
      t.index :post_id
      t.index :tag_id
      t.index [:post_id, :tag_id], unique: true
    end
  end
end
