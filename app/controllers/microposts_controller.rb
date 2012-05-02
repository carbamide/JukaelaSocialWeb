class MicropostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy

  def index
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      @micropost.content.scan(/"([^"]*)"/)  { |u| 
         if @user = User.find_by_name(u)
           UserMailer.mentioned_email(@user, current_user).deliver
         end
      }
        
      twitter_style_username_regex = /(?<=^|(?<=[^a-zA-Z0-9-_\.]))@([A-Za-z]+[A-Za-z0-9]+)/
      
      @micropost.content.scan(twitter_style_username_regex) { |u|
        if @user = User.find_by_username(u)
          UserMailer.mentioned_email(@user, current_user).deliver
        end
      }
          
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def repost_post(post)
    @micropost = post
    if @micropost.save
      @micropost.content.scan(/"([^"]*)"/)  { |u| 
         if @user = User.find_by_name(u)
           UserMailer.mentioned_email(@user, current_user).deliver
         end
      }
            
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end

  private
  def authorized_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_path if @micropost.nil?
  end
end
