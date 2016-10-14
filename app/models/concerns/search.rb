module Search
  
  def self.search_listings_and_spots(search_params, max_distance=Settings.search.distance)
    results = []
    gon_locations = []
    
    # search listings
    if search_params['sort_by'].blank? || search_params['sort_by'] == 'Tour'
      result_array = Listing.search(search_params, max_distance)
      if result_array.present?
        listing_ids = result_array[0]
        listing_destination_ids = result_array[1]

        gon_locations += ListingDestination.select('longitude, latitude').where(id: listing_destination_ids)
        listings = Listing.where(id: listing_ids)

        # sort
        if listings.present?
          listings = listings.sort_for_search
        end

        results += listings
      end
    end

    # search spots
    if search_params['sort_by'].blank? || search_params['sort_by'] == 'Spot'
      spots = Spot.search(search_params, max_distance)
      if spots.present?
        gon_locations += spots

        if results.present?
          results = results.zip(spots).flatten.compact
        else
          results += spots
        end
      end
    end
    
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