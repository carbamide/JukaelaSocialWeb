class PagesController < ApplicationController
  def home
    @title = "Home"
        
    respond_to do |format|
      format.html  {
        if signed_in?
          @micropost = Micropost.new
          @feed_items = current_user.feed.paginate(:page => params[:page])
        end
      }
      format.json {
        if signed_in?
          @feed_items = current_user.feed.slice!(params[:first].to_i, params[:last].to_i)
          
          render :json => @feed_items, :methods => :users_who_liked
        else
          raise "Not currently signed in!"
        end
      }
    end
  end
    
  def contact
    @title = "Contact"
  end
    
  def about
    @title = "About"
  end
    
  def help
    @title = "Help"
  end
    
  def news
    @title = "News"
  end
    
  def mentions
    @title = "Mentions"
    respond_to do |format|
      format.html  {
        if signed_in?
          @mentions = current_user.mentions.paginate(:page => params[:page])
        end
      }
      format.json {
        if signed_in?
          @mentions  = current_user.mentions.slice!(params[:first].to_i, params[:last].to_i)
          render :json => @mentions
        else
          raise "Not currently signed in!"
        end
      }
    end
  end
end
