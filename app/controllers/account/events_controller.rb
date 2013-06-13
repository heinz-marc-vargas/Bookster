class Account::EventsController < ApplicationController
  before_filter :authenticate_user!

  def appt_customers
    load_company
    render :layout => false
  end
  
  def list
    session[:active_main_tab] = "events"

    render :layout => false
  end
  
  def add_note
    @event = Event.find(params[:id])

    unless params[:note][:contents].blank?
      @note = Note.new(params[:note])
      @note.noteable =  @event
      @note.save
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def notes_list
    @event = Event.find(params[:id])
    render :layout => false
  end
  
  def notes
    @event = Event.find(params[:id])
    render :layout => false
  end

  def todays
    session[:active_main_tab] = "events"

    render :layout => false
  end

  def list_datable
    respond_to do |format|
      format.json
    end
  end

  # GET /events
  # GET /events.xml
  def index
    # full_calendar will hit the index method with query parameters
    # 'start' and 'end' in order to filter the results for the
    # appropriate month/week/day.  It should be possiblt to change
    # this to be starts_at and ends_at to match rails conventions.
    # I'll eventually do that to make the demo a little cleaner.
    @events = current_user.events_list
    @events = @events.after(params['start']) if (params['start'])
    @events = @events.before(params['end']) if (params['end'])
    @redirect_url = url_for(:controller =>'calendar')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.js  { render :json => @events }
    end
  end

  # GET /events
  # GET /events.xml
  def filter

    filters = params[:id].split('9')
    event_conditions = []

    if filters[0].to_i > 0
      event_conditions << format("staff_id = %d", filters[0].to_i)
    end
    if filters[1].to_i > 0
      event_conditions << format("service_id = %d", filters[1].to_i)
    end
    if filters[2].to_i > 0
      event_conditions << format("user_id = %d", filters[2].to_i)
    end

    p event_conditions.join(" AND ")

    @events = Event.scoped
    @events = @events.after(params['start']) if (params['start'])
    @events = @events.before(params['end']) if (params['end'])
    @events = @events.find(:all, :conditions => event_conditions.join(" AND "))
    @redirect_url = url_for(:controller =>'calendar')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.js  { render :json => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false }
      format.xml  { render :xml => @event }
      format.js { render :json => @event.to_json }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    #@event = Event.new

    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.xml  { render :xml => @event }
    #end
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html { render :layout => false }
      format.js
    end
    
  end

  # POST /events
  # POST /events.xml
  def create
=begin
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
=end
    @event = params[:event] != nil ? Event.new(params[:event]) : Event.new
    respond_to do |format|
      if @event.save
        @events = Event.order("starts_at")
        #format.json { render :json => @event, :status => :created }
        if session[:active_main_tab] == "events"
          format.html { redirect_to('/event_list', :notice => 'Appointment was successfully created.') }
        else
          format.html { redirect_to('/calendar', :notice => 'Appointment was successfully created.') }
        end
      else
        format.json { render :json => @event.errors, :status => :bad_request }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  # PUT /events/1.js
  # when we drag an event on the calendar (from day to day on the month view, or stretching
  # it on the week or day view), this method will be called to update the values.
  # viv la REST!
  # def update
  #   @event = Event.find(params[:id])

  #   respond_to do |format|
  #     if @event.update_attributes(params[:event])
  #       format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
  #       format.xml  { head :ok }
  #       format.js { head :ok}
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
  #       format.js  { render :js => @event.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    @success = I18n.t("event_deleted")

    respond_to do |format|
      format.js
    end
  end

  def update
    @event = Event.find(params[:event][:id])

    unless params[:event][:starts_at].nil?
      if params[:event][:starts_at].to_s.include?("/")
        # 02/22/2013
        arr = params[:event][:starts_at].split("/")
        params[:event][:starts_at] = "#{arr[2]}-#{arr[0]}-#{arr[1]}"
      end       
    end
    
    if @event.update_attributes(params[:event])
      @success = I18n.t('event_updated')
    end

    respond_to do |format|
      format.js
    end
  end

  def view_event
    logger.info "EDIT................."
    respond_to do |format|
      format.js
    end
  end

  def view
    @event = Event.find(params[:id])
    render :layout => false
  end

  def filter_events
    start_date = params[:start_date] if params[:start_date]
    end_date = params[:end_date] if params[:end_date]
    filter = params[:filter]
    @events = Event.order("starts_at")
    if (filter != nil)
      if (filter == "today")
        @events = Event.find_by_sql("SELECT * FROM events WHERE starts_at BETWEEN '" + Date.today.strftime("%Y-%m-%d") + "' AND '" + (Date.today+1.days).strftime("%Y-%m-%d") + "'")
      elsif (filter == "tomorrow")
        @events = Event.find_by_sql("SELECT * FROM events WHERE starts_at BETWEEN '" + (Date.today+1.days).strftime("%Y-%m-%d") + "' AND '" + (Date.today+2.days).strftime("%Y-%m-%d") + "'")
      elsif (filter == "last_7_days")
        @events = Event.find_by_sql("SELECT * FROM events WHERE starts_at BETWEEN '" + (Date.today-7.days).strftime("%Y-%m-%d") + "' AND '" + (Date.today).strftime("%Y-%m-%d") + "' ORDER BY starts_at")
      else
        if (end_date != nil)
          date_time = start_date.split("_")
          date = date_time[0].split("-").reverse
          date = date[0] + "-" + date[2] + "-" + date[1]
          start_date = (date + " " + date_time[1]).to_datetime

          date_time = end_date.split("_")
          date = date_time[0].split("-").reverse
          date = date[0] + "-" + date[2] + "-" + date[1]
          end_date = (date + " " + date_time[1]).to_datetime
          @events = Event.find_by_sql("SELECT * FROM events WHERE starts_at BETWEEN '" + start_date.strftime("%Y-%m-%d %H:%M") + "' AND '" + (end_date+1.days).strftime("%Y-%m-%d %H:%M") + "' ORDER BY starts_at")
        end
      end
    end
    render :partial => "events_list"
  end

  def update_time
    @event = Event.find(params[:event][:id])

    @result = @event.update_time(params[:event][:dayDelta], params[:event][:minuteDelta])
  end
end
