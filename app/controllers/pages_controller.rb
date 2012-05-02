class PagesController < ApplicationController
  def home
    @title = "Home"
    if signed_in?
      @micropost = Micropost.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
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
    
    if signed_in?      
      @mentions = current_user.mentions.paginate(:page => params[:page])
    end
  end
  
end
