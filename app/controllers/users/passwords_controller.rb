class Users::PasswordsController < Devise::PasswordsController
	layout 'login_screen'
	
	def confirmation
	  if request.post?    
  	  @user = User.find_by_email(params[:user][:email])
  	  
  	  unless @user.nil?
        if ["staff", "owner", "customer"].include?(@user.role.to_s) && @user.confirmed_at.nil?
          @user.send_confirmation_instructions
          redirect_to auth_users_passwords_confirmation_path(:sent => 1)
        else
          @user.errors.add(:base, t('errors.messages.email_activated'))
        end
      else
        flash[:error] = t('errors.messages.not_found')
      end
    end
          
	end
	
	def create
	  @user = User.find_by_email(params[:user][:email])

    unless @user.nil?
      if ["staff", "owner", "customer"].include?(@user.role.to_s) && @user.confirmed_at.nil?
        @user.errors.add(:base, t('errors.messages.notexists'))
        flash[:error] = t('errors.messages.notexists')
        redirect_to auth_users_passwords_confirmation_path(:p => 1, :email => @user.email)
      else
        flash[:notice] = "We've sent password reset instructions to your email address."
      end
    else
      super  
    end
	end
end