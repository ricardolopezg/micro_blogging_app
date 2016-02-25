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

get "/acct" do

  erb :acct
end

post "/acct" do

  #update command with params

  redirect "/acct"
end


post "/" do

  @user = User.where(email: params[:email]).first
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:notice] = "Welcome home motherfucker"
    puts @current_user 

<<<<<<< HEAD
		redirect "/"
	else
		flash[:alert] = "Wrong info motherfucker"
		redirect "/"
	end
end

def current_user
	@current_user = User.find(session[:user_id])
=======

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
>>>>>>> master
end

get "/feed" do 

  erb :feed
end

