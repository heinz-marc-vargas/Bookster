class StepsController < ApplicationController
  layout 'wizard'
  before_filter :load_company
  before_filter :check_status

  def validate_subdomain
    @res = Company.is_unique_subdomain?(@company, params[:sub])
    
    respond_to do |format|
      format.js
    end
  end
  
  def complete
    redirect_to root_path
  end
  
  def confirmation
    @company.update_attribute(:progress_status, "complete")
    if session[:subdomain] != session[:prev_subdomain]

      @company.update_attribute(:subdomain, session[:subdomain])
      session[:subdomain] = nil
      session[:prev_subdomain] = nil
      @company.reload
    end

    Mailer.new_subdomain(current_user).deliver
  end
  
  def notifications
    redirect_to staffs_steps_path if @company.branches.first.services.empty?
    @branch = @company.branches.first
    
    if request.post?
      if params[:enable].nil?
        @branch.update_attribute(:notify_enabled, 0)
      else
        @branch.notify_enabled = params[:enable]
        @branch.notify_options = { :email => params[:email], :frequency => params[:frequency] }
        @branch.save
      end
      
      @company.next_status('confirmation') if @company.progress_status == 'notifications'
      redirect_to confirmation_steps_path
    end
  end
  
  def avatar
    @staff = current_user.companies.first.branches.first.staff.find(params[:id])
    
    @staff.user.avatar = params[:avatar]
    @staff.user.save
    
    respond_to do |format|
      format.js

    end
  end
  
  def addservice
    @service = Service.new
    services = Service.where("branch_id IN (?) AND service_category_id is not null", @company.branches.map(&:id))
    @categories = ServiceCategory.where("id IN (?)", services.map(&:service_category_id))
    
    
    if request.post?
      @service = Service.new(params[:service])
      @service.status = 1
      
      if params[:service][:service_category_id].to_s == "0"
        cat = ServiceCategory.create(:name => params[:new_category])
        @service.service_category_id = cat.id
      end

      if @service.save
        # saving staffs selected
        unless params[:staff].nil?
          params[:staff].each do |staff_id|
            staff = Staff.find(staff_id) rescue nil
            staff.services << @service unless staff.nil?
          end
        end
        
        @company.next_status('notifications') if @company.progress_status == 'services' 
      end

      
    end
      
    
    respond_to do |format|
      format.html { render :layout => false }
      format.js
    end
  end
  
  def addstaff
    @user = User.new
    @staff = Staff.new
    
    if request.post?
      @user = User.new(params[:user])
      @user.role = "staff"
      @user.status = 1
      @user.skip_confirmation!
      
      if @user.save

        @staff = Staff.new(params[:staff])

        if @staff.save
          @user.resource = @staff
          @user.save
          @company.users << @user

          @company.next_status('services') if @company.progress_status == 'staffs'
        else
          @user.delete
          @user = User.new
        end        
      end
      
      @staff.reload
      @user.reload
    end
    
    respond_to do |format|
      format.html { render :layout => false }
      format.js
    end
  end
  
  def business
    
    if request.put?
      if @company.update_attributes(params[:company])
        @company.next_status('hours') if @company.progress_status == 'details'
        @saved = true
        
        begin
          @company.save!
          @company.copy_address_to_branches
          
          session[:pre_subdomain] = @company.subdomain
          session[:subdomain] = params[:subdomain]

          @company.reload
          redirect_to hours_steps_path
        rescue Exception => e
          flash[:error] = e.message.to_s
        end
      end
    end
  end
  
  def hours
    @branch = @company.branches.first
    
    if request.put?
      save_operating_times(params)
      @branch.company.next_status('staffs') if @company.progress_status == "hours"
      
      redirect_to staffs_steps_path
    end
  end
  
  def staffs
    @staffs = @company.branches.first.staff
  end
  
  def services
    redirect_to staffs_steps_path if @company.branches.first.staff.empty?
    @services = @company.branches.first.services
  end
  
  def save_operating_times(params)
    @branch.operating_days.destroy_all
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
        od.resource = @branch
        od.operating_hour = oh
        od.save
      end
    end
  end
  
  def check_status
    redirect_to root_path if @company.progress_status == "complete"
  end
end