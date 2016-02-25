class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username 
      t.string :email
      t.string :password
      t.string :fname
      t.string :lname
      t.string :sign
      t.datetime :birthday 
      t.string :gender
    end
  end
end
