class Admin::SessionsController < ApplicationController
  
  
  def new
    
  end
  
  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid User/Password"
      render "new"
      return
    else
      sign_in(user)
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
  
end
