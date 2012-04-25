class UserMailer < ActionMailer::Base
  default :from => "support@jukaela.com"
 
  def welcome_email(user)
    @user = user
    @url  = "http://cold-planet-7717.herokuapp.com/signin"
    mail(:to => user.email, :subject => "Welcome to My Awesome Site")
  end
end