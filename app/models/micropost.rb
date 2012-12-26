class Micropost < ActiveRecord::Base
    attr_accessible :content, :user_id, :repost_user_id, :repost_name, :repost_username, :name, :username, :email, :image_url, :in_reply_to

  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 256 }
  validates :user_id, :presence => true
  validates :name, :presence => true
  
  default_scope :order => 'microposts.created_at DESC'

  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private
  def self.followed_by(user)
    following_ids = %(SELECT followed_id FROM relationships
    WHERE follower_id = :user_id)
    where("user_id IN (#{following_ids}) OR user_id = :user_id",
    { :user_id => user })
  end
end
