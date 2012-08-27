class PagesController < ApplicationController
  def home
    @title = "Home"

    respond_to do |format|
        format.html  { 
          if signed_in?
            @micropost = Micropost.new
              #raise params.inspect
            @feed_items = current_user.feed.paginate(:page => params[:page])
          end
        }
        format.json  {
            @feed_items = current_user.feed
          render :json => @feed_items 
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
    
    if signed_in?      
      @mentions = current_user.mentions.paginate(:page => params[:page])
    end
  end
  
end
