class DirectMessage < ActiveRecord::Base
    attr_accessible :content, :from_name, :from_user_id, :from_username, :user_id, :from_email
    belongs_to :user
    
    validates :content, presence: true, length: { maximum: 256 }
    validates :from_name, presence: true
    validates :from_user_id, presence: true
    validates :from_username, presence: true
    
    default_scope :order => 'direct_messages.created_at DESC'

end
