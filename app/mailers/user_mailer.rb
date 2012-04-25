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
end