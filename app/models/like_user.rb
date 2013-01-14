class LikeUser < ActiveRecord::Base
  attr_accessible :name, :user_id, :username, :micropost_id, :email
end
