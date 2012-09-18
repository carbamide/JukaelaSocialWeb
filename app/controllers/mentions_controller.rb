class MentionsController < ApplicationController
    before_filter :authenticate, :only => [:create, :destroy]
    before_filter :authorized_user, :only => :destroy
    
    def index
        respond_to do |format|
            format.html # index.html.erb
            format.json  { render :json => current_user.mentions.all }
        end
    end
    
    def create
        @mention = current_user.mentions.build(params[:micropost])
        
        @micropost = current_user.microposts.build(params[:micropost])
        
        if @mention.save
            flash[:success] = "Micropost created!"
            redirect_to root_path
            else
            @feed_items = []
            render 'pages/home'
        end
    end
    
    def destroy
        @mention.destroy
        redirect_back_or root_path
    end
    
    private
    def authorized_user
        @mention = current_user.mentions.find_by_id(params[:id])
        redirect_to root_path if @mention.nil?
    end
end
