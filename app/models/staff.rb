class Staff < ActiveRecord::Base
  set_table_name "staff"

  belongs_to :branch
  has_many   :events  
  has_one    :user, :as => :resource
  has_many   :operating_days, :dependent => :destroy
  has_many   :operating_days, :as => :resource, :dependent => :destroy
  has_and_belongs_to_many :services
  has_many   :closed_dates, :as => :blockable, :dependent => :destroy
  validates_associated :user

  scope :deleted, lambda {|deleted| {:conditions => ["staff.deleted = ?", deleted] }}
  scope :branch, lambda {|branch_id| {:conditions => ["staff.branch_id = ?", branch_id] }}
  scope :quick_search, lambda {|search_text| 
    {
      :include => :user,
      :conditions => ["lower(users.email) LIKE '%%%s%%' OR
                      lower(users.first_name) LIKE '%%%s%%' OR
                      lower(users.last_name) LIKE '%%%s%%'", search_text, search_text, search_text]
    }
  }
  scope :without_deleted, :conditions => {:deleted => 0}

  before_create :set_role_for_user

  def full_name
    return "" if user.nil?
    "#{user.full_name}"
  end

  def get_time_slots(sdate = Date.today, service_id = nil)
    puts sdate.inspect
    
    service_duration = Service.find(service_id).duration * 60
    day_to_int = sdate.to_time.to_i
    timeslots = Hash.new
    timeslots["am"] = Array.new
    timeslots["pm"] = Array.new
    timeslots["am_time"] = Array.new
    timeslots["pm_time"] = Array.new

    od = self.branch.operating_days.find_by_day_of_week(sdate.wday)

    if od.nil?
      return timeslots
    end

    conditions = format("starts_at >= '%s' AND starts_at <= '%s'", Time.at(day_to_int).to_date.to_formatted_s(:db), Time.at(day_to_int + 1.day.to_i).to_date.to_formatted_s(:db))
    same_day_events = self.events.find(:all, :conditions => conditions)

    slot = od.operating_hour.am_start_time
    while (slot + service_duration) <= (od.operating_hour.am_end_time)
      match = false
      same_day_events.each do | sde |
        if ((slot + day_to_int) < sde.ends_at.to_i) && (sde.starts_at.to_i < (slot + day_to_int + service_duration))
          slot = sde.ends_at.to_i - day_to_int
          match = true
          next
        end
      end
      if !match
        timeslots["am"] << slot
        timeslots["am_time"] << format("%d:%02d", (slot / 3600), (slot.divmod(3600)[1] / 60))
        slot += service_duration
      end
    end

    slot = od.operating_hour.pm_start_time
    while (slot + service_duration) <= (od.operating_hour.pm_end_time)
      match = false
      same_day_events.each do | sde |
        if ((slot + day_to_int) < sde.ends_at.to_i) && (sde.starts_at.to_i < (slot + day_to_int + service_duration))
          slot = sde.ends_at.to_i - day_to_int
          match = true
          next
        end
      end
      if !match
        timeslots["pm"] << slot
        timeslots["pm_time"] << format("%d:%02d", (slot / 3600), (slot.divmod(3600)[1] / 60))
        slot += service_duration
      end
    end

    return timeslots
  end

private

  def set_role_for_user
    unless user.nil?
      user.role = :staff
      user.save
    end
  end

end
