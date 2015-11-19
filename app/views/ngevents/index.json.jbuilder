json.array!(@ngevents) do |event|
  json.extract! event, :id, :start, :end, :color
  json.className do
    json.array! ['fa', 'fa-close']
  end
end
