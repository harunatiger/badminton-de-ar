json.array!(@ngevent_weeks) do |week|
  json.id(week.id)
  json.color('gray')
  json.selectable('false')
  json.editable('false')
  json.className do
    json.array! ['ng-event-week', 'listing' + (week.listing_id).to_s]
  end
  json.dow do
    json.array! [week.dow]
  end
end
