require "sinatra"
require "sinatra/activerecord"
require "sinatra/reloader"
require "./models"
require "sinatra/flash"
require "paperclip"
require "tempfile"
require "blockspring"


enable :sessions
set :sessions, true

set :database, "sqlite3:horo.db"

get "/" do   

  if session[:user_id]

    redirect "/feed"

  end

  erb :home

end


# ACCOUNT >>>>>>>>>>>>>>>>>>>
get "/acct" do

  if session[:user_id] == nil

    redirect "/"

  end

    @following = Follower.where(follower_id: current_user.id)
    
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
  user.update_attribute(:location, params[:location]) if params[:location] != ""
  user.update_attribute(:known_for, params[:known_for]) if params[:known_for] != ""
  user.update_attribute(:favorite_games, params[:favorite_games]) if params[:favorite_games] != ""
  user.update_attribute(:goals, params[:goals]) if params[:goals] != ""


  redirect "/acct"
end

post "/deleteAcct" do

  current_user.destroy

  Post.where(user_id: current_user.id).destroy_all
  
  Follower.where(follower_id: current_user.id).destroy_all

  Follower.where(followee_id: current_user.id).destroy_all

  flash[:acctDelete] = "Your info is DELETED motherfucker"

  session[:user_id] = nil

  redirect "/"
end

post "/unfollow" do

  Follower.where(followee_id: params[:notFollowingAnymore], follower_id: current_user.id).destroy_all

  redirect "/acct"

end

# BROWSE >>>>>>>>>>>>>>>>>>>>>>>>

get "/browse" do

  if session[:user_id] == nil

    redirect "/"

  end

  @users = User.all

  erb :browse
end


# post '/upload' do
#     unless params[:file] &&
#            (tmpfile = params[:file][:tempfile]) &&
#            (name = params[:file][:filename])
#       @error = "No file selected"
#       return haml(:upload)
#     end
#     STDERR.puts "Uploading file, original name #{name.inspect}"
#     while blk = tmpfile.read(65536)
#       # here you would write it to its final location
#       STDERR.puts blk.inspect
#     end
#     "Upload complete"
#     redirect "/acct"
#   end


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
  session[:user_id] = nil
   flash[:logout] = "Good bye motherfucker"

  redirect "/"
end

post "/signup" do
  User.create(username: params[:username], password: params[:password], 
    email: params[:email] )
  @user = User.where(email: params[:email]).first
  session[:user_id] = @user.id

  flash[:welcome] = "Thanks for joining motherfucker"

  redirect "/feed"

end





# PROFILE >>>>>>>>>>>>>>>>>>>
get "/profile/:id/:username" do 

  if session[:user_id] == nil
    redirect "/"
  end

  def user_textbox_display
    User.find(session[:user_id]) == User.find(@profile_id)
  end

  @posts = Post.where(user_id: params[:id])

  @profile_id = params[:id]

  @profile_username = params[:username]

  @followers = Follower.where(followee_id: params[:id] )

  @fname = User.find(params[:id]).fname
  @lname = User.find(params[:id]).lname
  @email = User.find(params[:id]).email
  @sign = User.find(params[:id]).sign
  @gender = User.find(params[:id]).gender
  @birthday = User.find(params[:id]).birthday
  @location = User.find(params[:id]).location
  @known_for = User.find(params[:id]).known_for
  @favorite_games = User.find(params[:id]).favorite_games
  @goals = User.find(params[:id]).goals

  erb :profile
end

get "/profile" do
  if session[:user_id] == nil
    redirect "/"
  end

  redirect "/profile/#{current_user.id}/#{current_user.username}"
end


post "/addPost" do 
  if session[:user_id] == nil
    redirect "/"
  end

  Post.create(user_id: current_user.id,content: params[:content], post_date: Time.now )

  redirect "/profile/#{current_user.id}/#{current_user.username}"

end


post "/deletePost" do
  if session[:user_id] == nil
    redirect "/"
  end

  Post.find(params[:post_delete]).destroy

  redirect "/profile/#{current_user.id}/#{current_user.username}"
end



post "/updatePost" do
  if session[:user_id] == nil
    redirect "/"
  end

    Post.find(params[:post_update]).update(content: params[:content])

  redirect "/profile/#{current_user.id}/#{current_user.username}"

end



post '/upload' do
# post '/upload' do
#     unless params[:file] &&
#            (tmpfile = params[:file][:tempfile]) &&
#            (name = params[:file][:filename])
#       @error = "No file selected"
#       return haml(:upload)
#     end
#     STDERR.puts "Uploading file, original name #{name.inspect}"
#     while blk = tmpfile.read(65536)
#       # here you would write it to its final location
#       STDERR.puts blk.inspect
#     end
#     "Upload complete"
#     redirect "/profile/#{current_user.id}"
end



patch "/editPost" do

  Post.find(params[:post_edit]).update

  redirect "/profile/#{current_user.id}/#{current_user.username}/"

end


post "/follow" do

  Follower.create(followee_id: params[:followee], follower_id: current_user.id)

  @followee_num = params[:followee]
  followee_name = User.find(@followee_num).username

  flash[:follow] = "You are now following #{followee_name}!"

  redirect "/profile/#{@followee_num}/#{followee_name}"

end





# FEED >>>>>>>>>>>>>>>>>>>
get "/feed" do 
  if session[:user_id] == nil

    redirect "/"

  end

  current_user.sign

  @posts = Post.all
  @last_ten_posts = Post.last(10)

  erb :feed
end

