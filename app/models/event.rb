class Event < ActiveRecord::Base
  include Inpendium::Integrate

  DAYS_REMINDERS = [1, 3]
  
  STATUSES = {
    "Processing" => 0,   
    "Complete"   => 1,
    "No Show"    => 2,
    "Cancelled"  => 3
  }

  belongs_to :service
  belongs_to :staff
  belongs_to :customer
  belongs_to :branch
  has_many :notes, :as => :noteable
  belongs_to :customer, :polymorphic => true, :dependent => :destroy

  validates :starts_at, :presence => true
  validates :service_id, :presence => true
  validates :staff_id, :presence => true
  validates :customer_id, :presence => true
  validates :branch_id, :presence => true

  scope :before, lambda {|end_time| {:conditions => ["ends_at < ?", Event.format_date(end_time)] }}
  scope :after, lambda {|start_time| {:conditions => ["starts_at > ?", Event.format_date(start_time)] }}
  scope :service, lambda {|service_id| {:conditions => ["service_id = ?", service_id] }}
  scope :staff, lambda {|staff_id| {:conditions => ["staff_id = ?", staff_id] }}
  scope :branch, lambda {|branch_id| {:conditions => ["branch_id = ?", branch_id] }}

  scope :datable_searching, Proc.new{|query|
    {
      :joins => [:branch, :service, {:staff => :user}, {:customer => :user}],
      :conditions => [
        "branches.name  LIKE '%%%s%%' OR
         services.name LIKE '%%%s%%' OR
         services.duration LIKE '%%%s%%' OR
         users.first_name LIKE '%%%s%%' OR
         users.last_name LIKE '%%%s%%' OR
         users_customers.first_name LIKE '%%%s%%' OR
         users_customers.last_name LIKE '%%%s%%' OR
         events.starts_at LIKE '%%%s%%'",
        query, query, query, query, query, query, query, query
      ]
    }
  }

  scope :datable_sorting_by_branch, Proc.new{|sort|
    {
     :joins => :branch,
     :order => "branches.name #{ sort }"
    }
  }

  scope :datable_sorting_by_service, Proc.new{|sort|
    {
     :joins => :service,
     :order => "services.name #{ sort }"
    }
  }

  scope :datable_sorting_by_staff, Proc.new{|sort|
    {
     :joins => {:staff => :user},
     :order => "users.first_name #{ sort }"
    }
  }

  scope :datable_sorting_by_customer, Proc.new{|sort|
    {
     :joins => {:customer => :user},
     :order => "users.first_name #{ sort }"
    }
  }

  scope :datable_sorting_by_starts_at, Proc.new{|sort|
    {
      :order => "events.starts_at #{ sort }"
    }
  }

  scope :datable_sorting_by_duration, Proc.new{|sort|
    {
     :joins => :service,
     :order => "services.duration #{ sort }"
    }
  }

  before_save :set_ends_at
  after_update :send_review_link
  after_create :remind_branch_owner

  # need to override the json view to return what full_calendar is expecting.
  # http://arshaw.com/fullcalendar/docs/event_data/Event_Object/
  def as_json(options = {})
    {
      :id => self.id,
      :title => (Service.find(self.service_id).name rescue "N/A"),
      :description => self.description || "",
      :start => starts_at.rfc822,
      :end => ends_at.rfc822,
      :allDay => self.all_day,
      :recurring => false,
      :calendar_css => (Service.find(self.service_id).calendar_css rescue "info"),
      :staff => (self.staff.full_name rescue "N/A"),
      :customer => (self.customer.full_name rescue "N/A"),
      :user => (User.find(self.user_id).full_name rescue "N/A"),
      #:url => Rails.application.routes.url_helpers.url_for(:controller => 'events', :action => 'view_event', :id => self.id, :only_path => true)
      #:url => Rails.application.routes.url_helpers.event_path(id)
    }

  end

  def set_ends_at
    self.ends_at = self.starts_at + (60 * Service.find(self.service_id).duration)
  end

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)
  end

  def duration
    (service.duration.to_s + " minutes") rescue "N/A"
  end

  def appointment_date
    self.starts_at.strftime('%B %d, %Y') rescue "N/A"
  end

  def appointment_span
    (self.starts_at.strftime('%H:%M %p') + "-" + self.ends_at.strftime('%H:%M %p')) rescue "N/A"
  end

  def service_count(service_id, month_id)
    this_month = Date.new(y = Date.now.year, m = month_id)
    self.after(this_month)
    self.before(this.month + 1.month)
    self.count
  end

  def update_time(day_delta, minute_delta)
    self.starts_at += day_delta.to_i.days + minute_delta.to_i.minutes

    save
  end
  
  def completed?
    (status == 1)
  end
  
  def send_review_link
    return if !completed?
    
    review = Review.where("event_id = ? AND customer_id = ?", self.id, self.customer_id)
    if review.empty?
      ReviewLink.create_link(self)
      AppointmentMailer.delay.send_review_link(self)
    end
  end
  
  def remind_branch_owner
    frequency = self.branch.notify_options[:frequency] rescue nil
    return if frequency.nil?
    
    if frequency == "everytime"
      
    end
  end
  
end
