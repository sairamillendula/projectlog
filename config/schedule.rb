set :output, "#{path}/log/cron_log.log"
set :environment, 'development'


every 1.day, :at => '01:00 AM' do
  rake "subscription:process_modifications"
end

every 1.day, :at => '01:02 AM' do
  rake "user:revert"
end

every 1.day, :at => '01:04 AM' do
  rake "user:alert_expire"
end

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
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
