class MicropostsController < ApplicationController
    before_filter :authenticate, :only => [:create, :destroy]
    before_filter :authorized_user, :only => :destroy
    
    def index
        respond_to do |format|
            format.html # index.html.erb
            format.json {
                @feed_items = current_user.feed.all.slice!(params[:first].to_i, params[:last].to_i)
                render :json => @feed_items
            }
        end
    end
    
    def create
        @micropost = current_user.microposts.build(params[:micropost])
        @micropost.name = current_user.name
        @micropost.username = current_user.username
        @micropost.email = current_user.email
        
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
                                                    :user_id => temp_user.id,
                                                    :sender_email => current_user.email,
                                                    :sender_name => current_user.name,
                                                    :sender_username => current_user.username)
                @mention.save
                
                send_push_notification(temp_user, @micropost)
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
                                                        :user_id => temp_user.id,
                                                        :sender_email => current_user.email,
                                                        :sender_name => current_user.name,
                                                        :sender_username => current_user.username)
                    @mention.save
                    
                    send_push_notification(temp_user, @micropost)
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
            
        end
    end
    
    def send_push_notification(temp_user, micropost)
        if temp_user.apns
            temp_user.apns.each do |a|
                notification = {
                    :device_tokens => [a.device_token],
                    :aps => {:alert => 'From ' + current_user.name + ' - ' + @micropost.content, :badge => 1}
                }
                Urbanairship.push(notification)
            end
        end
    end
    
    def destroy
        @micropost.destroy
        redirect_back_or root_path
    end
    
    def repost
        respond_to do |format|
            format.html
            format.json {
                mp = Micropost.find(params[:id])
                
                @micropost = current_user.microposts.build(:name => mp.name, :username => mp.username, :email => mp.email, :content => mp.content, :user_id => mp.user_id, :repost_user_id => current_user.id, :repost_name => current_user.name, :repost_username => current_user.username)
                
                @micropost.save
                
                render :json => @micropost
            }
        end
    end
    
    private
    def authorized_user
        @micropost = current_user.microposts.find_by_id(params[:id])
        redirect_to root_path if @micropost.nil?
    end
end
