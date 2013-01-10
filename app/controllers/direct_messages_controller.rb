class DirectMessagesController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
    
  def index
    respond_to do |format|
      format.json  { render :json => current_user.direct_messages.all }
    end
  end
    
  def create
    respond_to do |format|
      format.html { render :text => 'This is html' }
      format.json  {
        user_message_is_going_to = User.find_by_username(params[:username]);
                
        @direct_message = user_message_is_going_to.direct_messages.build(:content => params[:direct_message][:content],
        :from_name => current_user.name,
        :from_user_id => current_user.id,
        :from_username => current_user.username,
        :from_email => current_user.email,
        :user_id => user_message_is_going_to.id)
                
        if @direct_message.save
          send_push_notification(user_message_is_going_to)
        end
      }
    end
  end
    
  def destroy
    @direct_message.destroy
    redirect_back_or root_path
  end
    
  private
  def authorized_user
    @direct_message = current_user.direct_messages.find_by_id(params[:id])
    redirect_to root_path if @direct_messages.nil?
  end
    
  def send_push_notification(temp_user)
    if temp_user.apns
      temp_user.apns.each do |a|
        notification = {
          :device_tokens => [a.device_token],
          :aps => {:alert => 'Direct Message From ' + current_user.name, :badge => 1}
        }
        Urbanairship.push(notification)
      end
            
      temp_user.apids.each do |a|
        notification = {
          :apids => [a.device_token],
          :android =>{:alert => 'Direct Message From ' + current_user.name}
        }
                
        Urbanairship.push(notification)
      end
    end
  end
end