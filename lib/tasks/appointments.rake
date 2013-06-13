namespace :app do
	namespace :appointments do
	  
		desc "Reminding customers of appointments"
		task :reminder => :environment do
      Event.where("starts_at >= ?", Time.now).find_each(:batch_size => 10) do |event|
        Event::DAYS_REMINDERS.each do |day_reminder|
          if day_reminder.day.from_now >= event.starts_at &&
          	(event.reminder_delivered_at.nil? || (event.starts_at - day_reminder.day) > event.reminder_delivered_at)

            event.transaction do
            	event.reminder_delivered_at = event.starts_at - day_reminder.day
            	event.day_reminder = day_reminder
            	event.save!

              AppointmentMailer.delay.reminder(event, day_reminder)
              break
            end
            
          end
        end
      end
		end
		
	end
	
	namespace :companies do
    desc "Remind company/business owners"
    task :reminder => :environment do
      Company.without_deleted.where("status=1").find_each(:batch_size => 50) do |company|
        company.branches.each do |branch|
          next if branch.notify_options.nil?
          freq = branch.notify_options[:frequency].to_s rescue ''

          if freq == "day"
            if branch.reminded_at.nil? || branch.reminded_at.to_date < Time.current.to_date
              branch.update_attribute(:reminded_at, Time.current) 
              AppointmentMailer.delay.appointment_summary(branch)
            end
          end

          if freq == "weekly"
            if branch.reminded_at.nil? || ((Time.current.to_date - branch.reminded_at.to_date)  == 7 && branch.reminded_at.to_date != Time.current.to_date)
              branch.update_attribute(:reminded_at, Time.current) 
              AppointmentMailer.delay.appointment_summary(branch)
            end
          end          

        end
      end
    end	  
	
	end
end