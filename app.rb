require "sinatra"
require "sinatra/activerecord"
require "sinatra/reloader"
require "./models"
require "sinatra/flash"

enable :sessions
set :sessions, true

set :database, "sqlite3:horo.db"

get "/" do   

  erb :home

end

get "/acct" do

  # current_user

  erb :acct
end

post "/acct" do

  user = current_user

  user.update_attribute(:username, params[:username])

  # puts current_user.username
  # puts params[:username]

  # @user.username = params[:username] if !params[:username].nil?

  # @current_user.save

  redirect "/acct"
end

get "/browse" do

  @users = User.all

  erb :browse
end


post "/" do

  @user = User.where(email: params[:email]).first
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:notice] = "Welcome home motherfucker"

		redirect "/"
	else
		flash[:alert] = "Wrong info motherfucker"
		redirect "/"
	end
end


def current_user
    @current_user = User.find(session[:user_id])
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

