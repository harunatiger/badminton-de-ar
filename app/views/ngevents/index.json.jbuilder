json.array!(@ngevents) do |event|
  json.extract! event, :id, :start, :end, :color
end 
