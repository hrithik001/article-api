class UpdatePostsTagsTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :posts_tags

    create_table :posts_tags do |t|
      t.references :post, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end

    add_index :posts_tags, [:post_id, :tag_id], unique: true, name: 'index_posts_tags_on_post_id_and_tag_id'
  end

  def down
    drop_table :posts_tags
  end
end
