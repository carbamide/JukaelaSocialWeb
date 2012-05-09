class RelationshipsController < ApplicationController
  before_filter :authenticate

  def create
    @user = User.find(params[:relationship][:followed_id])
        
    current_user.follow!(@user)
    
    UserMailer.following_email(@user, current_user).deliver
    
    raise current_user.inspect
    
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
      format.json { render :json => current_user }
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
