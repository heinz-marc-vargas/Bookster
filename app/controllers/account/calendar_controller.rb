class Account::CalendarController < ApplicationController
  before_filter :authenticate_user!
  layout :ajax_layout
  before_filter :check_company_setup, :only => [:index, :dashboard]

  def dashboard
  end
  
  def index
    load_company
    session[:active_main_tab] = "calendar"

    @staff_filter = 0
    @service_filter = 0
    @user_filter = 0
    
    @events = Event.scoped  
    @events = @events.after(params['start']) if (params['start'])
    @events = @events.before(Time.now.to_i)
    @total_completed = @events.count
    
    @events = Event.scoped
    @events = @events.after(params['start']) if (params['start'])
    @events = @events.before(params['end']) if (params['end'])
    @total = @events.count
    
    if @total > 0
      @percent = ((@total_completed * 100) / (@total * 100 )) * 100 
    else
      @percent = 0
    end
    
    @service_summary = Array.new
    Service.find(:all).each do | e |
      summary_info = Array.new
      summary_info << e.name rescue "N/A"
      events = Event.scoped  
      events = events.after(params['start']) if (params['start'])
      events = events.before(params['end']) if (params['end'])
      events = events.service(e.id)
      summary_info << events.count
      @service_summary << summary_info
    end

    @staff_summary = Array.new
    Staff.find(:all).each do | e |
      summary_info = Array.new
      summary_info << e.full_name rescue "N/A"
      events = Event.scoped  
      events = events.after(params['start']) if (params['start'])
      events = events.before(params['end']) if (params['end'])
      events = events.staff(e.id)
      summary_info << events.count
      @staff_summary << summary_info
    end
  end
  
  def filter_calendar
    @staff_filter = (params[:staff_filter].empty?) ? 0 : params[:staff_filter]
    @service_filter = (params[:service_filter].empty?) ? 0 : params[:service_filter]

    render :partial => "calendar"
  end
  
  def check_company_setup
    load_company
    redirect_to steps_path if !@company.complete?
  end
end
