class Mention < ActiveRecord::Base
    attr_accessible :content, :sender_user_id, :user_id, :sender_name, :sender_username, :sender_email
    belongs_to :user
    
    validates :content, presence: true, length: { maximum: 140 }
    validates :user_id, presence: true
    validates :sender_user_id, presence: true
    
    default_scope order: 'mentions.created_at DESC'
    
end
