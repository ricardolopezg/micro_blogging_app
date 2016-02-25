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


