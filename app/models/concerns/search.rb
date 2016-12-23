module Search
  def self.search_listings_and_spots(search_params, max_distance=Settings.search.distance)
    results = []
    gon_locations = []
    
    # search listings
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
end