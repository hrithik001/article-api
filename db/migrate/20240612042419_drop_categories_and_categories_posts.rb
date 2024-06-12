class DropCategoriesAndCategoriesPosts < ActiveRecord::Migration[7.1]
  def change
    drop_table :categories do |t|
      t.string :name, null: false
      t.timestamps null: false
    end

    drop_table :categories_posts do |t|
      t.integer :post_id, null: false
      t.integer :category_id, null: false
      t.index :category_id
      t.index :post_id
    end
  end
end
