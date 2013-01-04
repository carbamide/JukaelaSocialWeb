class MicropostsController < ApplicationController
    before_filter :authenticate, :only => [:create, :destroy]
    before_filter :authorized_user, :only => :destroy
    
    def index
        respond_to do |format|
            format.html # index.html.erb
        end
    end
    
    def show
        @microposts = Array.new
        
        micropost = Micropost.find(params[:id])
        
        @microposts.push(micropost)
        
        if micropost.in_reply_to?
            another_micropost = Micropost.find(micropost.in_reply_to)
            
            @microposts.push(another_micropost)
            
            if another_micropost.in_reply_to?
                begin
                    another_micropost = Micropost.find(another_micropost.in_reply_to)
                    
                    @microposts.push(another_micropost)
                end while another_micropost.in_reply_to?
            end
            
            respond_to do | format|
                format.html
            end
        end
    end
    
    def create
        if params[:micropost][:image]
            image_hash = Image.upload(params[:micropost][:image])
        end
        
        micropost_hash = params[:micropost]
        
        micropost_hash.delete("image")
        
        @micropost = current_user.microposts.build(micropost_hash)
        @micropost.name = current_user.name
        @micropost.username = current_user.username
        @micropost.email = current_user.email
        
        if image_hash
            @micropost.image_url = Image.original_image(image_hash)
        end
        
        if @micropost.save
            @micropost.content.scan(/"([^"]*)"/)  { |u|
            if @user = User.find_by_name(u)
                unless @user.nil?
                    if @user.send_email
                        UserMailer.mentioned_email(@user, current_user).deliver
                    end
                end
            end
            unless @user.nil?
                temp_user = @user
                
                @mention = temp_user.mentions.build(:content => @micropost.content,
                                                    :sender_user_id => current_user.id,
                                                    :user_id => temp_user.id,
                                                    :sender_email => current_user.email,
                                                    :sender_name => current_user.name,
                                                    :sender_username => current_user.username,
                                                    :image_url => @micropost.image_url)
                @mention.save
                
                send_push_notification(temp_user, @micropost)
            end
            }
            
            twitter_style_username_regex = /(?<=^|(?<=[^a-zA-Z0-9-_\.]))@([A-Za-z]+[A-Za-z0-9]+)/
            
            @micropost.content.scan(twitter_style_username_regex) { |u|
                if @user = User.find_by_username(u)
                    unless @user.nil?
                        if @user.send_email
                            UserMailer.mentioned_email(@user, current_user).deliver
                        end
                    end
                end
                unless @user.nil?
                    temp_user = @user
                    
                    @mention = temp_user.mentions.build(:content => @micropost.content,
                                                        :sender_user_id => current_user.id,
                                                        :user_id => temp_user.id,
                                                        :sender_email => current_user.email,
                                                        :sender_name => current_user.name,
                                                        :sender_username => current_user.username,
                                                        :image_url => @micropost.image_url)
                    
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
    
    def upload_image (file)
        return '' if file.nil?
        
        filename = clean_filename file.original_filename
        
        tmp_file_path = File.join(Rails.root, 'tmp', filename)
        
        imgur = send_to_imgur(file, tmp_file_path)
        
        imgur['image_hash']
    end
    
    def send_to_imgur(file, tmp_file_path)
        
        FileUtils.mv file.tempfile.path, tmp_file_path
        
        imgur = img.upload_file tmp_file_path
        
        FileUtils.rm tmp_file_path
        
        imgur
    end
    
    def thread_for_micropost
        @microposts_to_return = Array.new
        
        micropost = Micropost.find(params[:id])
        
        @microposts_to_return.push(micropost)
        
        if micropost.in_reply_to?
            another_micropost = Micropost.find(micropost.in_reply_to)
            
            @microposts_to_return.push(another_micropost)
            
            if another_micropost.in_reply_to?
                begin
                    another_micropost = Micropost.find(another_micropost.in_reply_to)
                    
                    @microposts_to_return.push(another_micropost)
                end while another_micropost.in_reply_to?
            end
            
            respond_to do |format|
                format.json {
                    render :json => @microposts_to_return
                }
                
            end
        end
    end
    
    def like
        micropost = Micropost.find(params[:id])
        
        lu = micropost.like_users.build(:name => current_user.name, :username => current_user.username, :user_id => current_user.id, :email => current_user.email)
        
        if micropost.like_users.find_by_user_id(current_user.id).nil?
            if lu.save
                temp_user = User.find(micropost.user_id)
                
                temp_user.apns.each do |a|
                    notification = {
                        :device_tokens => [a.device_token],
                        :aps => {:alert => 'Like from - ' + current_user.name + ' - ' + micropost.content, :badge => 1}
                    }
                    Urbanairship.push(notification)
                end
                
                temp_user.apids.each do |a|
                    notification = {
                        :apids => [a.device_token],
                        :android =>{:alert => 'Like from - ' + current_user.name + ' - ' + micropost.content}
                    }
                    
                    Urbanairship.push(notification)
                end
                
                if temp_user.send_email
                    UserMailer.liked_email(temp_user, current_user, micropost).deliver
                end
            end
            
            respond_to do |format|
                format.json {
                    render :json => micropost
                }
                format.html {
                    flash[:success] = "Liked!"
                    redirect_to root_path
                }
            end
        else
            respond_to do |format|
                format.json {
                    render :json => {:error => "Already liked"}
                }
                format.html {
                    flash[:error] = "Already liked! You can't like twice!"
                    redirect_to root_path
                }
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
                Urbanairship.provider = :ios
                Urbanairship.push(notification)
            end
            temp_user.apids.each do |a|
                notification = {
                    :apids => [a.device_token],
                    :android =>{:alert => 'From ' + current_user.name + ' - ' + @micropost.content}
                }
                
                Urbanairship.provider = :android
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
                
                @micropost = current_user.microposts.build(:name => mp.name, :username => mp.username, :email => mp.email, :content => mp.content, :user_id => mp.user_id, :repost_user_id => current_user.id, :repost_name => current_user.name, :repost_username => current_user.username, :image_url => mp.image_url)
                
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
