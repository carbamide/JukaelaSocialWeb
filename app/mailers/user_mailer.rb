class UserMailer < ActionMailer::Base
    default :from => "support@jukaela.com"
    
    def welcome_email(user)
        @user = user
        @url  = "http://cold-planet-7717.herokuapp.com/signin"
        
        mail(:to => user.email, :subject => "Welcome to Jukaela")
    end
    
    def following_email(user, user_thats_following)
        @user = user
        @following_user = user_thats_following
        @url  = "http://cold-planet-7717.herokuapp.com/signin"
        
        mail(:to => user.email, :subject => "You have a new follower on Jukaela!")
    end
    
    def mentioned_email(user, user_that_mentioned)
        @user = user
        @mentioning_user = user_that_mentioned
        @url = "http://cold-planet-7717.herokuapp.com/signin"
        
        mail(:to=> user.email, :subject => "You have been mentioned on Jukaela!")
    end
    
    def liked_email(user, liking_user, current_micropost)
        @user = user
        @the_user = liking_user
        @the_post = current_micropost
        
        @url = "http://cold-planet-7717.herokuapp.com/signin"
        
        mail(:to=> user.email, :subject => "You have been mentioned on Jukaela!")
    end
end