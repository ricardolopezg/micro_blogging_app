class AddColumn < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :known_for, :string
    add_column :users, :favorite_games, :string
    add_column :users, :goals, :string
  end
end

