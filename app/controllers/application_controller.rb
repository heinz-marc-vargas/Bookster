# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :correct_safari_and_ie_accept_headers
  before_filter :set_locale
  after_filter :set_xhr_flash

  def after_sign_in_path_for(resource_or_scope)
    account_dashboard_path
  end
  
  def set_xhr_flash
    flash.discard if request.xhr?
  end

  def get_conditions(search_text, fields)
    conditions = []
    fields.each do |f|
      conditions << format("lower(%s) LIKE '%%%s%%'", f, search_text)
    end
    return conditions
  end

  def correct_safari_and_ie_accept_headers
    ajax_request_types = ['text/javascript', 'application/json', 'text/xml']
    request.accepts.sort! { |x, y| ajax_request_types.include?(y.to_s) ? 1 : -1 } if request.xhr?
  end

  def confirm_logged_in
    unless user_signed_in?
      flash[:notice] = "Please log in."
      redirect_to(:controller => "access", :action => "login")
      return false
    else
      return true
    end
  end

  def ajax_layout
    (request.xhr?) ? nil : 'application'
  end

  def set_locale
    session[:lang] = params[:lang] unless params[:lang].blank?
    I18n.locale = session[:lang] || I18n.default_locale
  end

  def confirm_customer_logged_in
    unless session[:customer_id]
      flash[:notice] = (t :please_login)
      redirect_to(:controller => "customer_booking", :action => "login")
      return false
    else
      return true
    end
  end
  
  private
  
  def load_company
    @company = nil
    if (request.subdomain.present?)
      @company = Company.find_by_subdomain!(request.subdomain)
    end
  end
end
