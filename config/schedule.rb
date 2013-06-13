# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
 set :output, "#{path}/log/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every :hour do
  rake "app:appointments:reminder"
end

#every 5.minutes do
#  runner 'Mailer.tester.deliver'
#end

#daily and weekly owner/companies reminders
every 2.hours do
  rake "app:companies:reminder"
end

# set :path, ""
# set :environment, ""
# set :output, ""
#every 1.minute do
	#job_type :script, "cd :path && RAILS_ENV=:environment bundle exec script/delayed_job run :output"

#end
