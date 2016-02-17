json.array!(@ngevent_weeks) do |week|
  json.id(week.id)
  json.color('#17aedf')
  json.selectable('false')
  json.editable('false')
  json.className do
    json.array! ['ng-event-week', 'fa', 'fa-close']
  end
  json.dow do
    json.array! [week.dow]
  end
end
