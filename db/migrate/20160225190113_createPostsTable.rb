class CreatePostsTable < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :content
      t.datetime :post_date
    end
  end
end
