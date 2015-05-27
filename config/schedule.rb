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

#work_hour_per_two = ('6'..'24').to_a.collect {|x| ["#{x}:00"] if x%3 == 0}.flatten
#every 1.day, at: work_hour_per_two do
#  rake "review_mail:send"
#end

every 1.day at: '0:55 pm' do
  rake "review_mail:send"
end
# Learn more: http://github.com/javan/whenever
