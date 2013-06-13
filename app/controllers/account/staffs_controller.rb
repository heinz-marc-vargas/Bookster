class Account::StaffsController < ApplicationController
  before_filter :authenticate_user!
  #before_filter :set_company_id
  before_filter :load_company
  layout false, :only => [:index]

  def index
    session[:active_main_tab] = "staff"

    unless params[:company_id].blank?
      @company = Company.find(params[:company_id])
    end
    
    unless session[:company_id].nil?
      @company = Company.find(session[:company_id])
    end
    
    staff_ids = current_user.staff_list(@company.id).without_deleted.map(&:id)

    @users = User.by_staff_ids(staff_ids)
  end

  def filter
    session[:active_main_tab] = "staff"
    search_text = params[:search_text].downcase
    @staff_list = scoped_list(params, search_text)
    render :layout => false
  end

  # def scoped_list(params = nil, search_text = nil)
  #   staff_list = current_user.staff_list(@company_id).scoped
  #   staff_list = search_text ? staff_list.quick_search(search_text) : staff_list.deleted(0)
  #   session[:current_page] = params[:page] ? params[:page] : 0
  #   return staff_list.paginate(:page => params[:page], :per_page => session[:per_page])
  # end

  def new
    @staff = Staff.new
    @staff.user = User.new
    @branches = current_user.branches_list_by_company_id(@company.id)
    @services = current_user.services_list_by_company_id(@company.id)
    render :layout => false
  end

  def edit
    @staff = Staff.includes(:operating_days).find(params[:id])
    if current_user.admin?
      @branches = Branch.where("company_id = ?", session[:company_id])
      @services = Service.where("branch_id IN (?)", @branches.map(&:id))
    else
      @branches = current_user.branches_list_by_company_id(@company.id)
      @services = current_user.services_list_by_company_id(@company.id)
    end
    
    render :layout => false
  end

  def show
    @staff = Staff.find(params[:id])
    render :layout => false
  end

  def create
    @user = User.new(params[:user])
    @user.role = "staff"
    @user.status = 1
    @user.skip_confirmation!
    @user.avatar = params[:photo] unless params[:photo].nil?
      
    @staff = Staff.new(params[:staff])

    if @user.save

      @staff.user = @user
      @staff.save!
      @company.users << @user
      
      save_services(params)
      save_operating_times(params)
      
      @success = format((t :staff_added_new), @staff.user.full_name, (@staff.branch.name rescue ''))
    end

    respond_to do |format|
      format.html { redirect_to account_dashboard_path(:path => "/account/staffs") }
      format.js
    end
  end

  def update
    @staff = Staff.find(params[:staff][:id])

    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
    params[:staff].delete("id")

    if (@staff.user.update_attributes(params[:user]) && @staff.update_attributes(params[:staff]))
      save_services(params)
      save_operating_times(params)

      @staff.user.avatar = params[:photo] unless params[:photo].nil?
      @staff.user.save

      @success = format((t :staff_saved), @staff.user.full_name)
      Rails.logger.info("&&& SUCCESS: " + @success.inspect)
    else
      @branches = current_user.branches_list_by_company_id(@company.id)
      @services = current_user.services_list_by_company_id(@company.id)
    end
    
    respond_to do |format|
      format.html { redirect_to account_dashboard_path(:path => "/account/staffs") }
      format.js
    end
  end

  def delete
    staff = Staff.find(params[:id])
    staff.deleted = 1
    staff.save
    @success = format((t :staff_deleted), staff.user.full_name)

    respond_to do |format|
      format.js
    end
  end

  def save_services(params)
    @staff.services.clear
    Service.all.each do |s|
      if params["service_" + s.id.to_s] != nil
        @staff.services << s
      end
    end
  end

  def edit_photo_list
    @staff = Staff.find(params[:id])
    render :partial => "edit_photo_list"
  end

  def upload_photo(staff_photo)
    Rails.logger.info("^^^^ " + staff_photo.inspect)
    File.open(Rails.root.join("app", "assets", "images", "staff", @staff.id.to_s + staff_photo.original_filename), 'wb') do |file|
      abc = file.write(staff_photo.read)
      Rails.logger.info("^^^^ " + abc.inspect)
    end
  end

  def mass_update
    ids = Array.new
    count = 0
    params.each do |p|
      if p[0][0..5] == "check_"
        s = Staff.find(p[1].to_i)
        if (params[:action_id] == "0")
          s.deleted = 1
        elsif (params[:action_id] == "1")
          s.status = 1
        elsif (params[:action_id] == "2")
          s.status = 0
        end
        count += 1
        s.save
      end
    end
    format_string = (params[:action_id] == "0") ? (t :staff_mass_deleted) : (t :staff_mass_updated)
    @success = format(format_string, count)
    @staff_list = scoped_list(params)
    render :action => "list"
  end

  #def set_company_id
  #  @company_id = session[:company_id_for_staff]
  #end

  def save_operating_times(params)
    @staff.operating_days.destroy_all
    0.upto(6) do |i|
      if (params["openday_" + i.to_s] != nil)
        oh = OperatingHour.new
        oh.am_start_time = params["start_time_am_" + i.to_s]
        oh.am_end_time = params["end_time_am_" + i.to_s]
        oh.pm_start_time = params["start_time_pm_" + i.to_s]
        oh.pm_end_time = params["end_time_pm_" + i.to_s]
        oh.save
        od = OperatingDay.new
        od.day_of_week = i
        od.resource = @staff
        od.operating_hour = oh
        od.save
      end
    end
  end
  
  def remove_cdate
    @cdate = ClosedDate.find(params[:id])
    @cdate.destroy
    
    respond_to do |format|
      format.js
      format.html
    end  
    
  end
  
  def closedate
    @cdate = ClosedDate.new
    @closed_dates = []
    
    if request.post?
      @cdate = ClosedDate.create_cdate(params[:staff][:staff_id], params, 'Staff')
      if @cdate.errors.empty? && @company.status != 'complete'
        @company.next_status('notifications')
      end
    end

    #Rails.logger.info "*** " + current_user.inspect
    if (current_user.role == "admin")
      @staffs = current_user.staff_list(0, true)
    else
      @staffs = current_user.staff_list(@company.id, false)
    end
    #@closed_dates = ClosedDate.where("branch_id IN (?)", @company.branches.map(&:id))
    @closed_dates = ClosedDate.where("blockable_id IN (?) AND blockable_type = 'Staff'", @staffs.map(&:id))
    Rails.logger.info("### CLOSED DATES: " + @closed_dates.inspect)
    
    respond_to do |format|
      format.js
      format.html
    end

  end

end
