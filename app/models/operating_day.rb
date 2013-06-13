class OperatingDay < ActiveRecord::Base
  belongs_to :branch
  belongs_to :staff
  belongs_to :resource, :polymorphic => true
  has_one :operating_hour, :dependent => :destroy
  
  def operating_time(with_day = false)
    am_time = format("%d:%02d-%d:%02d", (self.operating_hour.am_start_time / 3600), (self.operating_hour.am_start_time.divmod(3600)[1] / 60),
                                        (self.operating_hour.am_end_time / 3600), (self.operating_hour.am_end_time.divmod(3600)[1] / 60))
    pm_time = format("%d:%02d-%d:%02d", (self.operating_hour.pm_start_time / 3600), (self.operating_hour.pm_start_time.divmod(3600)[1] / 60),
                                        (self.operating_hour.pm_end_time / 3600), (self.operating_hour.pm_end_time.divmod(3600)[1] / 60))
    day_string = with_day ? Date::DAYNAMES[self.day_of_week] + ": " : ""
    return format("%s%s - %s", day_string, am_time, pm_time)
  end
  
  def operating_time_am
    format("%d:%02dAM - %d:%02dAM", (self.operating_hour.am_start_time / 3600), (self.operating_hour.am_start_time.divmod(3600)[1] / 60),
                                  (self.operating_hour.am_end_time / 3600), (self.operating_hour.am_end_time.divmod(3600)[1] / 60))
  end

  def operating_time_pm
    format("%d:%02dPM - %d:%02dPM", (self.operating_hour.pm_start_time / 3600), (self.operating_hour.pm_start_time.divmod(3600)[1] / 60),
                                  (self.operating_hour.pm_end_time / 3600), (self.operating_hour.pm_end_time.divmod(3600)[1] / 60))
  end
end
