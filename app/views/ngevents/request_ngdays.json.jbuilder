json.array!(@ngevents) do |event|
  json.id(event.id)
  json.start(event.start)
  json.end(event.end)
  json.color('#E8868F')
  json.className do
    json.array! ['listing' + (event.listing_id).to_s, 'mode' + (event.mode).to_s, 'ng-event-request']
  end
end
