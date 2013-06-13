class ClosedDate < ActiveRecord::Base
  belongs_to :blockable, :polymorphic => true
  
  class << self
    def create_cdate(blockable_id, params, blockable_type)
      cdate = ClosedDate.new
      
      start_date_time = (params[:start_date] + " " + params[:start_time]).to_datetime rescue nil
      end_date_time = (params[:end_date]  + " " + params[:end_time]).to_datetime rescue nil
      
      #dups = where("branch_id=? AND (? BETWEEN start_date AND end_date) OR (? BETWEEN start_date AND end_date)", branch_id, start_date, end_date)
      dups = where("blockable_type = '" + blockable_type + "' AND blockable_id=? AND ((? BETWEEN start_date_time AND end_date_time) OR (? BETWEEN start_date_time AND end_date_time))", blockable_id, start_date_time, end_date_time)
      
      Rails.logger.info("DUPS: " + dups.inspect)
      
      unless dups.empty?
        cdate.errors.add(:Date, "clash with existing dates")
      else
        cdate.start_date_time = start_date_time
        cdate.end_date_time   = end_date_time
        cdate.blockable_type = blockable_type
        cdate.blockable_id  = blockable_id
        cdate.total_days = (params[:end_date].to_date - params[:start_date].to_date).to_i + 1
        cdate.label      = params[:label]
        cdate.save!
      end
      
      cdate
    end
    
  end
  
  def dates_covered    
    dates = []

    if self.total_days > 1
      dates << self.start_date_time.to_date
      cur_date = self.start_date_time.to_date
      
      while cur_date.next_day != self.end_date_time.to_date
        dates << cur_date
        cur_date = curdate.next_day
      end
    else
      dates << self.start_date_time.to_date
    end
    
    dates
    
  end
  
end
