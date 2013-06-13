class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
    user = User.from_omniauth(env["omniauth.auth"])

    if user.errors.empty?
	    sign_in user

	    if current_user
	      flash[:notice] = "Signed in successfully."

	      redirect_to '/customer_booking'
	    end
	  else
      flash[:notice] = "Authorization failed."

      redirect_to '/customer_booking/login'
	  end
	end
end