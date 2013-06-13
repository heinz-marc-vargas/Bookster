class Account::UsersController < ApplicationController
  before_filter :authenticate_user!
  layout false, :only => [:index, :filter, :profile, :show, :edit, :new]

  def index
    session[:active_main_tab] = 'users'
    @users = User.for_manage.order("users.first_name ASC")
    authorize! :manage, User, :message => "Opps"    
  end

  def list_datatable
    respond_to do |format|
      format.json
    end
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @success = (t :users_added_new)
    end

    respond_to do |format|
      format.js
    end
  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? && params[:user][:password_confirmation].blank?

    if @user.update_attributes(params[:user])
      @success = format((t :user_saved), @user.full_name)
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    @success = format(t(:user_deleted), user.full_name)

    respond_to do |format|
      format.js
    end
  end

  def filter
    session[:active_main_tab] = 'users'
    search_text = params[:search_text].downcase
    @users = scoped_list(params, search_text)
  end

  def profile
    @user = current_user

    if request.put?
      params[:user].delete(:password) if params[:user][:password].blank?
      params[:user].delete(:password_confirmation) if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
  
      @user.avatar = params[:fileinput] unless params[:fileinput].nil?

      if @user.update_attributes(params[:user])
        @success = format((t :user_saved), @user.full_name)
      end
    end
        
    respond_to do |format|
      format.js
      format.html { redirect_to account_dashboard_path(:path => "/account/users/profile") if request.put? }
    end
    
  end

  def password
    @user = User.find(params[:id])
    render :layout => false
  end

  def save_password
    @user = User.find(params[:user][:id])
    if params[:user][:password] != params[:user][:password_confirmation]
      @error = "Passwords do not match"
      render :action => "update_password"
    elsif params[:user][:password].blank? || params[:user][:password_confirmation].blank?
      @error = "Missing field value"
      render :action => "update_password"
    else
      @user.update_attributes(params[:user])
      if @user.save
        @success = format("Password for %s has been successfully saved.", @user.username)
        @users = User.order("username")
        render :action => "list"
      else
        render :action => "update_password"
      end
    end
  end

  def upload_avatar
  end

  def mass_update
    ids = Array.new
    count = 0
    params.each do |p|
      if p[0][0..5] == "check_"
        s = User.find(p[1].to_i)
        if (params[:action_id] == "0")
          s.destroy
        elsif (params[:action_id] == "1")
          s.status = 1
        elsif (params[:action_id] == "2")
          s.status = 0
        end
        count += 1
        s.save
      end
    end
    format_string = (params[:action_id] == "0") ? (t :user_mass_deleted) : (t :user_mass_updated)
    @success = format(format_string, count)
    @users = scoped_list(params)
    render :action => :index
  end
  
  def companies
    @user = User.find(params[:id])
  end

  def assign_company
    @user = User.find(params[:id])

    if !params[:user][:companies].blank? && company = Company.find(params[:user][:companies])
      @user.companies << company unless @user.companies.include?(company)
    end
  end

  def revoke_company
    @user = User.find(params[:id])

    company = @user.companies.find(params[:company_id])

    @user.companies.delete(company) if company

    render :action => 'companies'
  end
end
