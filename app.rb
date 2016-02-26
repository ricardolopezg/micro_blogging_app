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


# ACCOUNT >>>>>>>>>>>>>>>>>>>
get "/acct" do

  # current_user

  erb :acct
end

post "/acct" do

  user = current_user

  user.update_attribute(:username, params[:username]) if params[:username] != ""
  user.update_attribute(:email, params[:email]) if params[:email] != ""
  user.update_attribute(:password, params[:password]) if params[:password] != ""
  user.update_attribute(:fname, params[:fname]) if params[:fname] != ""
  user.update_attribute(:lname, params[:lname]) if params[:lname] != ""
  user.update_attribute(:birthday, params[:birthday]) if params[:birthday] != ""
  user.update_attribute(:gender, params[:gender]) if params[:gender] != ""
  user.update_attribute(:sign, params[:sign]) if params[:sign] != ""

  redirect "/acct"
end

get "/browse" do

  @users = User.all

  erb :browse
end


# SIGNUP/LOGIN >>>>>>>>>>>>>>>>>>>
post "/" do

  @user = User.where(email: params[:email]).first
  if @user && @user.password == params[:password]
    session[:user_id] = @user.id
    flash[:notice] = "Welcome home motherfucker"

    redirect "/feed"
  else
    flash[:alert] = "Wrong info motherfucker"
    redirect "/"
  end
end


  def current_user
    @current_user = User.find(session[:user_id])
  end


get "/logout" do
  session[:username] = nil
   flash[:logout] = "Good bye motherfucker"

  redirect "/"
end

post "/signup" do
	User.create(username: params[:username], password: params[:password], 
		email: params[:email] )
	redirect "/feed"

end





# PROFILE >>>>>>>>>>>>>>>>>>>
get "/profile" do 
  @posts = Post.all
  
  erb :profile
end

post "/profile" do 

  Post.create(user_id: current_user.id,content: params[:content], post_date: Time.now )
  redirect "/profile"


end


# FEED >>>>>>>>>>>>>>>>>>>
get "/feed" do 

  erb :feed
end

