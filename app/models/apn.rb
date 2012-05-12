class Apn < ActiveRecord::Base
  attr_accessible :device_token

  belongs_to :user
  
  validates :device_token, :presence   => true,
  :uniqueness => { :case_sensitive => false }
end