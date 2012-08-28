class UsersController < ApplicationController
    
    before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
    before_filter :correct_user, :only => [:edit, :update]
    before_filter :admin_user,   :only => :destroy
    
    def new
        @user = User.new
        @title = "Sign up"
    end
    
    def create
        @user = User.new(params[:user])
        if @user.save
            respond_to do |format|
                format.html {
                    sign_in @user
                    flash[:success] = "Welcome"
                    redirect_to @user }
                format.json { render :json => @user }
            end
            UserMailer.welcome_email(@user).deliver
            else
            @title = "Sign up"
            render 'new'
        end
    end
    
    def edit
        @title = "Edit user"
    end
    
    def update
        @user = User.find(params[:id])
        if @user.update_attributes(params[:user])
            
            respond_to do |format|
                format.html { flash[:success] = "Profile updated."
                    redirect_to @user }
                format.json { render :json => @user }
            end
            else
            @title = "Edit user"
            render 'edit'
        end
    end
    
    def index
        @title = "All users"
        @users = User.paginate(:page => params[:page])
        
        respond_to do |format|
            format.html # index.html.erb
            format.json  { render :json => User.all }
        end
    end
    
    def show
        @user = User.find(params[:id])
        @microposts = @user.microposts.paginate(:page => params[:page])
        @mentions = @user.mentions.paginate(:page => params[:page])
        @title = @user.name
        
        respond_to do |format|
            format.html
            format.json  { render :json => @user }
        end
    end
    
    def show_microposts_for_user
        @user = User.find(params[:id])
        @microposts = @user.microposts.all
        
        respond_to do |format|
            format.json { render :json => @microposts }
        end
    end
    
    def destroy
        User.find(params[:id]).destroy
        flash[:success] = "User destroyed."
        redirect_to users_path
    end
    
    def following
        @title = "Following"
        @user = User.find(params[:id])
        @users = @user.following.paginate(:page => params[:page])
        
        respond_to do |format|
            format.html { render 'show_follow' }
            format.json { render :json => {:user => @user.following.all,
                :relationships => current_user.relationships.find_by_followed_id(@user)}}
        end
    end
    
    def followers
        @title = "Followers"
        @user = User.find(params[:id])
        @users = @user.followers.paginate(:page => params[:page])
        
        respond_to do |format|
            format.html { render 'show_follow' }
            format.json { render :json => @user.followers.all }
        end
    end
    
    private
    def correct_user
        @user = User.find(params[:id])
        redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
        redirect_to(root_path) unless current_user.admin
    end
    
    
end
