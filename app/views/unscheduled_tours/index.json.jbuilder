json.array!(@unscheduled_tours) do |unscheduled_tour|
  json.extract! unscheduled_tour, :id
  json.url unscheduled_tour_url(unscheduled_tour, format: :json)
end
