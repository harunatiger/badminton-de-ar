json.array!(@ngevents) do |event|
  json.id(event.id)
  json.start(event.start)
  json.end(event.end)
  json.color('#DF1717')
  json.className do
    json.array! ['mode' + (event.mode).to_s, 'ng-event-listing-request','fa', 'fa-close']
  end
end
