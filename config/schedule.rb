set :output, 'log/crontab.log'
set :environment, ENV["RAILS_ENV"]

every 1.day, at: '3:00 am' do
  rake "week_before_notification:send"
end

every 1.day, at: '3:30 am' do
  rake "day_before_notification:send"
end

every 1.day, at: '4:00 am' do
  rake "review_mail:send"
end

every 1.day, at: '4:30 am' do
  rake "noreply_notification:send"
end

every 1.day, at: '5:00 am' do
  rake "review_open:do"
end
# Learn more: http://github.com/javan/whenever