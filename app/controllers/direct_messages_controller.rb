class DirectMessagesController < ApplicationController
    before_filter :authenticate, :only => [:create, :destroy]
    before_filter :authorized_user, :only => :destroy
    
    def index
        respond_to do |format|
            format.html # index.html.erb
            format.json  { render :json => current_user.direct_messages.all }
        end
    end
    
    def create
        @direct_message = current_user.direct_messages.build(params[:direct_message])
        
        if @direct_message.save
            flash[:success] = "direct_message created!"
            redirect_to root_path
            else
            @feed_items = []
            render 'pages/home'
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