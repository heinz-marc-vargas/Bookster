class OperatingHour < ActiveRecord::Base
  belongs_to :operating_day
  
  def self.create_op_hours(am_start_time = nil, am_end_time = nil, pm_start_time = nil, pm_end_time = nil, od_id = 0)
    hrs = OperatingHour.new(:am_start_time => am_start_time, :am_end_time => am_end_time, :pm_start_time => pm_start_time, :pm_end_time => pm_end_time, :operating_day_id => od_id)
    hrs.save
    
    return hrs
  end

  def update_op_hours(am_start_time = nil, am_end_time = nil, pm_start_time = nil, pm_end_time = nil, od_id = 0)
    saved = false
    
    self.am_start_time = am_start_time.to_i
    self.am_end_time = am_end_time.to_i
    self.pm_start_time = pm_start_time.to_i
    self.pm_end_time = pm_end_time.to_i
    self.operating_day_id = od_id
    saved = self.save
    
    return saved
  end
  
  def self.delete_op_hours(op_hours_id = nil)
    if (op_hours_id != nil)
      OperatingHours.delete(op_hours_id.to_i)
    end
  end
  
  def get_operating_hours
    am_start = (self.am_start_time / 3600).to_s
    am_end = (self.am_end_time / 3600).to_s
    pm_start = (self.pm_start_time / 3600).to_s
    pm_end = (self.pm_end_time / 3600).to_s
    
    if (am_start == "0")
      am_start = "0000"
    end
    
    if (am_start.length == 3)
      am_start = "0" + (self.am_start_time / 3600).to_s
    elsif (am_start.length == 1)
      am_start = "0" + (self.am_start_time / 3600).to_s + "00"
    end
    
    if (am_end == "0")
      am_end = "0000"
    end
    
    if (am_end.length == 3)
      am_end = "0" + (self.am_start_time / 3600).to_s
    elsif (am_start.length == 1)
      am_start = "0" + (self.am_start_time / 3600).to_s + "00"
    end
    
    if (pm_start.length == 2)
      pm_start = pm_start + "00"
    end
    
    if (pm_end.length == 2)
      pm_end = pm_end + "00"
    end
    
    return am_start + "-" + am_end + ", " + pm_start + "-" + pm_end
  end
  
  def self.get_select_am_times
    return ["0000", "0030", "0100", "0130", "0200", "0230", "0300", "0330", "0400", "0430", "0500", "0530", "0600", "0630", "0700", "0730", "0800", "0830", "0900", "0930", "1000", "1030", "1100", "1130", "1159" ]
  end
  
  def self.get_select_pm_times
    return ["1200", "1230", "1300", "1330", "1400", "1430", "1500", "1530", "1600", "1630", "1700", "1730", "1800", "1830", "1900", "1930", "2000", "2030", "2100", "2130", "2200", "2230", "2300", "2330", "2359" ]
  end

end
