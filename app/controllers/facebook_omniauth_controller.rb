class FacebookOmniauthController < ApplicationController
  def login
  	#debugger
    user = User.from_omniauth(request.env["omniauth.auth"])

    sign_in user
    redirect_to :controller => :customer_booking, :action => :index
  end

  def logout
    sign_out
    redirect_to :controller => :customer_booking, :action => :login
  end
end