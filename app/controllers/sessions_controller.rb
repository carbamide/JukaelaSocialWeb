class SessionsController < ApplicationController
    def new
        @title = "Sign in"
    end
    
    def create
        session[:staysignedin] = (params[:session][:stay_signed_in] == "1") ? true : false
        
        user = User.authenticate(params[:session][:email], params[:session][:password])
        
        if params[:session][:apns]
            if params[:session][:apns].length == 64
                apn = user.apns.build(:device_token => params[:session][:apns])
            else
                apn = user.apids.build(:device_token => params[:session][:apns])
            end
            
            apn.save
        end
        
        if user
            user.apns.each do |a|
                Urbanairship.register_device a.device_token
            end
            
            user.apids.each do |ap|
                Urbanairship.register_device(ap.device_token, :provider => :android)
            end
        end
        
        respond_to do |format|
            format.html {
                if user.nil?
                    flash.now[:error] = "Invalid email/password combination."
                    @title = "Sign in"
                    render 'new'
                else
                    sign_in user
                    redirect_back_or root_path
                end
            }
            format.json  { 
                sign_in user
                
                render :json => user.to_json
            }
        end
        
    end
    
    def destroy
        sign_out
        redirect_to root_path
    end
end
