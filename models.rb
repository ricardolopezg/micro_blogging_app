class User < ActiveRecord::Base
  has_many :posts
  has_many :followers

  attr_accessor :username
end

class Post < ActiveRecord::Base
  belongs_to :user
end

class Follower < ActiveRecord::Base
  has_many :users
end