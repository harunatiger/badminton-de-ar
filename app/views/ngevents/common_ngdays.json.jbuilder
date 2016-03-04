json.array!(@ngevents) do |event|
  json.id(event.id)
  json.start(event.start)
  json.end(event.end)
  json.color('black')
  json.className do
    json.array! ['listing' + (event.listing_id).to_s, 'mode' + (event.mode).to_s, 'ng-event-common']
  end
end
