require "sinatra"
require "sinatra/activerecord"
require "sinatra/reloader"
require "./models"
require "sinatra/flash"

enable :sessions

set :database, "sqlite3:horo.db"

get "/" do   

	erb :home
end

get "/profile" do 
  @posts = Post.all
  
  erb :profile
end

post "/profile" do 
  Post.create(user_id: user.id, content: [params:content], post_date: Time.now)
  redirect "/profile"
end

get "/feed" do 

  erb :feed
end