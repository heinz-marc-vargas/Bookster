class Users::SessionsController < Devise::SessionsController
  layout 'login_screen'

  def new
    load_company
    super
    
    unless params[:c].blank?
      flash[:notice] = t :successfully_activated
    end
  end

  def create
    load_company
  	super
    
    if current_user
      if current_user.role == "customer"
        session[:company_id] = current_user.resource.company.id
      else
        session[:company_id] = current_user.companies.first.id
      end
      
      session[:per_page] = 20
      I18n.locale = current_user.country.locale rescue 'en'
      flash[:notice] = t :logged_in      
      current_user.remember_me! unless params[:user][:remember_me].nil?
    else
      session[:username] = nil
      session[:company_id] = nil
      flash[:notice] = t :invalid_login
    end

  end
  
  def destroy
    super
  end
end