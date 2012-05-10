class MicropostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  def index
    respond_to do |format|
          format.html # index.html.erb
          format.json  { render :json => @micropost }
    end
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    @micropost.name = current_user.name
    
    if @micropost.save
      @micropost.content.scan(/"([^"]*)"/)  { |u| 
         if @user = User.find_by_name(u)
           unless @user.nil?
             UserMailer.mentioned_email(@user, current_user).deliver
           end
         end
         unless @user.nil?
           temp_user = @user
         
           @mention = temp_user.mentions.build(:content => @micropost.content, 
                                            :sender_user_id => current_user.id, 
                                            :user_id => temp_user.id)
           @mention.save
           
#           if temp_user.apns
 #            n = Rapns::Notification.new
  #           n.device_token = temp_user.apns
   #          n.alert = @micropost.content
    #         n.badge = 1
     #        n.expiry = 1.day.to_i
      #       n.deliver_after = 30.seconds.from_now
       #      n.save!
        #  end
         end
      }
        
      twitter_style_username_regex = /(?<=^|(?<=[^a-zA-Z0-9-_\.]))@([A-Za-z]+[A-Za-z0-9]+)/
      
      @micropost.content.scan(twitter_style_username_regex) { |u|
        if @user = User.find_by_username(u)
          unless @user.nil?
            UserMailer.mentioned_email(@user, current_user).deliver
          end
        end
        unless @user.nil?
          temp_user = @user
        
          @mention = temp_user.mentions.build(:content => @micropost.content, 
                                           :sender_user_id => current_user.id, 
                                           :user_id => temp_user.id)
          @mention.save
          
          #           if temp_user.apns
           #            n = Rapns::Notification.new
            #           n.device_token = temp_user.apns
             #          n.alert = @micropost.content
              #         n.badge = 1
               #        n.expiry = 1.day.to_i
                #       n.deliver_after = 30.seconds.from_now
                 #      n.save!
                  #  end
        end
      }
          
      respond_to do |format|
        format.html {
          flash[:success] = "Micropost created!"
          redirect_to root_path
          puts @micropost.to_json
        }
        format.json  { render :json => @micropost }
      end
      
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
