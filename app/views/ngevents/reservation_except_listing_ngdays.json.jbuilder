json.array!(@ngevents) do |event|
  json.id(event.id)
  json.start(event.start)
  json.end(event.end)
  json.color('#800080')
  json.className do
    json.array! ['mode' + (event.mode).to_s, 'ng-except-listing','fa', 'fa-close']
  end
end
