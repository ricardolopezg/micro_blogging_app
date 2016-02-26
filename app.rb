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


# ACCOUNT >>>>>>>>>>>>>>>>>>>
get "/acct" do

  erb :acct
end

post "/acct" do

  #update command with params

  redirect "/acct"
end


# SIGNUP/LOGIN >>>>>>>>>>>>>>>>>>>
post "/" do

  @user = User.where(email: params[:email]).first
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:notice] = "Welcome home motherfucker"
    puts @current_user 


    redirect "/"
  else
    flash[:alert] = "Wrong info motherfucker"
    redirect "/"
  end
end


def current_user
    @current_user = User.find(session[:user_id])
end

# PROFILE >>>>>>>>>>>>>>>>>>>
get "/profile" do 
  @posts = Post.all
  
  erb :profile
end

post "/profile" do 

  @timestamp = Time.now.strftime("%b %-d, %Y  %l:%M%p")


  Post.create(content: params[:content], post_date: @timestamp)
  redirect "/profile"

end


# FEED >>>>>>>>>>>>>>>>>>>
get "/feed" do 

  erb :feed
end

