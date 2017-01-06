module Search
  def self.search_listings_and_spots(search_params, max_distance=Settings.search.distance)
    results = []
    gon_locations = []
    
    # search listings
    #search_params = self.set_lon_lat(search_params)
    result_array = Listing.search(search_params, max_distance)
    if result_array.present?
      listing_ids = result_array[0]
      listing_destination_ids = result_array[1]

      gon_locations += ListingDestination.select('longitude, latitude, listing_id').where(id: listing_destination_ids)
      listings = Listing.where(id: listing_ids)

      # sort
      if listings.present?
        listings = listings.sort_for_search
      end

      results += listings
    end
    
    # =========sort by (uniq user) and (in alternate)=========
    # TODO delete spot search
    if results.present?
      uniq_results = results.uniq {|e| e.model_name.to_s + e.user_id.to_s }
      duplicated_results = results - uniq_results
      results_buf = uniq_results.concat(duplicated_results).partition{|r| r.model_name == 'Listing' }

      #results_buf[0] == listings array, results_buf[1] == spots array
      if results_buf[0].present? && results_buf[1].present?
        results = results_buf[0].zip(results_buf[1]).flatten.compact
        results_buf[1].each do |spot|
          results.push(spot) unless results.include?(spot)
        end
      else
        results = results_buf[0] if results_buf[0].present?
        results = results_buf[1] if results_buf[1].present?
      end
    end
    # ===========================================================
    
    if results.present?
      if listings.present?
        return {results: results, gon_locations: gon_locations, listings: listings}
      else
        return {results: results, gon_locations: gon_locations, listings: nil}
      end
    end
    {results: nil, gon_locations: nil, listings: nil}
  end
  
  def self.distance(from_x, from_y, to_x, to_y)
    from_x = from_x * Math::PI / 180
    from_y = from_y * Math::PI / 180
    to_x = to_x * Math::PI / 180
    to_y = to_y * Math::PI / 180
    earth_r = 6378140
    
    deg = Math::sin(from_y) * Math::sin(to_y) + Math::cos(from_y) * Math::cos(to_y) * Math::cos(to_x - from_x)
    distance = earth_r * (Math::atan(-deg / Math::sqrt(-deg * deg + 1)) + Math::PI / 2) / 1000
  end
  
  def self.inner_bounds?(bounds, lon, lat)
    # js => [bounds_sw.lng(), bounds_sw.lat(), bounds_ne.lng(), bounds_ne.lat()]
    bounds_array = bounds.split(',')
    west = bounds_array[0].to_f
    south = bounds_array[1].to_f
    east = bounds_array[2].to_f
    north = bounds_array[3].to_f
    return true if (west < lon && lon < east) && (south < lat && lat < north )
    false
  end
  
  def self.set_lon_lat(params)
    hash = Hash.new
    if params['location'].present? && (params["longitude"].blank? || params["latitude"].blank?)
      hash = self.geocode_with_google_map_api(params['location'])
    end
    if hash['success'].present?
      params['longitude'] = hash['lng']
      params['latitude'] = hash['lat']
      params
    end
    params
  end

  def self.geocode_with_google_map_api(location)
    base_url = "http://maps.google.com/maps/api/geocode/json"
    address = URI.encode(location)
    hash = Hash.new
    reqUrl = "#{base_url}?address=#{address}&sensor=false&language=ja"
    response = Net::HTTP.get_response(URI.parse(reqUrl))
    case response
    when Net::HTTPSuccess then
      data = JSON.parse(response.body)
      hash['lat'] = data['results'][0]['geometry']['location']['lat']
      hash['lng'] = data['results'][0]['geometry']['location']['lng']
      hash['success'] = true
    else
      hash['lat'] = 0.00
      hash['lng'] = 0.00
      hash['success'] = false
    end
    hash
  end
end