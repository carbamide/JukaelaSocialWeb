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
            format.json  {
                user_message_is_going_to = User.find_by_username(params[:username]);
                
                @direct_message = user_message_is_going_to.direct_messages.build(:content => params[:direct_message][:content],
                                                                                 :from_name => current_user.name,
                                                                                 :from_user_id => current_user.id,
                                                                                 :from_username => current_user.username,
                                                                                 :from_email => current_user.email,
                                                                                 :user_id => user_message_is_going_to.id)
                
                @direct_message.save
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
end