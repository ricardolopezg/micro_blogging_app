class CreateFollowersTable < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.integer :followee_id
      t.integer :follower_id
    end
  end
end
