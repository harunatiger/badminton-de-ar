class ChartData
  include ActiveModel::Model
  attr_accessor :day, :tour, :data, :benchmark, :chart_data
  
  def set_chart_data(listings)
    if listings.present?
      result = []
      benchmark_result = []
      if self.tour == Settings.chart_data.tours.all
        if self.data == Settings.chart_data.data.pv
          (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
            pv = BrowsingHistory.listings_pv(listings).viewed_when(date.beginning_of_day, date.end_of_day).count
            result.push([date.day.to_s,pv])
          end
        elsif self.data == Settings.chart_data.data.favorites
          (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
            favorites = FavoriteListing.listings_favorites(listings).created_when(date.beginning_of_day, date.end_of_day).count
            result.push([date.day.to_s,favorites])
          end
        elsif self.data == Settings.chart_data.data.sales
          (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
            sales = Reservation.seles_daily(listings, date)
            result.push([date.day.to_s,sales])
          end
        end
      else

        listing = Listing.find(self.tour)
        if self.benchmark.present?
          pickup = Pickup.find(self.benchmark.to_i)
          if pickup.pickup_area?
            benchmark_listings = pickup.listings
          elsif pickup.pickup_tag?
            benchmark_listings = pickup.listings_by_listing_images
          end
        end

        if self.data == Settings.chart_data.data.pv
          if self.benchmark.present?
            (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
              pv = BrowsingHistory.where(listing_id: listing.id).viewed_when(date.beginning_of_day, date.end_of_day).count
              benchmark_pv = BrowsingHistory.listings_pv(benchmark_listings).viewed_when(date.beginning_of_day, date.end_of_day).count
              result.push([date.day.to_s, pv, benchmark_pv / benchmark_listings.count])
            end
          else
            (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
              pv = BrowsingHistory.where(listing_id: listing.id).viewed_when(date.beginning_of_day, date.end_of_day).count
              result.push([date.day.to_s,pv])
            end
          end
        elsif self.data == Settings.chart_data.data.favorites
          if self.benchmark.present?
            (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
              favorites = FavoriteListing.where(listing_id: listing.id).created_when(date.beginning_of_day, date.end_of_day).count
              benchmark_favorites = FavoriteListing.listings_favorites(benchmark_listings).created_when(date.beginning_of_day, date.end_of_day).count
              result.push([date.day.to_s,favorites, benchmark_favorites / benchmark_listings.count])
            end
          else
            (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
              favorites = FavoriteListing.where(listing_id: listing.id).created_when(date.beginning_of_day, date.end_of_day).count
              result.push([date.day.to_s,favorites])
            end
          end
        elsif self.data == Settings.chart_data.data.sales
          if self.benchmark.present?
            (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
              sales = listing.sales_daily_amount(date)
              benchmark_sales = Reservation.seles_daily(benchmark_listings, date)
              result.push([date.day.to_s,sales, benchmark_sales / benchmark_listings.count])
            end
          else
            (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
              sales = listing.sales_daily_amount(date)
              result.push([date.day.to_s,sales])
            end
          end
        end
      end
    end
    
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'date' )
    data_table.new_column('number', 'value')
    data_table.new_column('number', 'average') if self.benchmark.present?
    data_table.add_rows(result)
    option = self.benchmark.present? ? { series: { 1 => { type: "line" } } } : {}
    self.chart_data = GoogleVisualr::Interactive::ColumnChart.new(data_table, option)
  end
  
  def tours_list(listings)
    list = [[Settings.chart_data.tours.all]]
    listings.each do |listing|
      list.push([listing.title, listing.id])
    end
    list
  end
  
  def data_list
    [Settings.chart_data.data.pv, Settings.chart_data.data.favorites, Settings.chart_data.data.sales]
  end
  
  def benchmark_list
    list = {}
    if self.tour != Settings.chart_data.tours.all
      listing = Listing.find(self.tour)
      area = []
      listing.pickups.each do |pickup|
        area.push([pickup.short_name, pickup.id])
      end
      list['AREA'] = area if area.present?
      
      category = []
      listing.listing_images.each do |listing_image|
        if listing_image.pickup_id.present?
          pickup = Pickup.find(listing_image.pickup_id)
          category.push([pickup.short_name, pickup.id])
        end
      end
      list['CATEGORY'] = category if category.present?
    end
    list
  end
  
  def pv_monthly_count(listings)
    if self.tour == Settings.chart_data.tours.all
      total = 0
      listings.each do |listing|
        total += listing.pv_monthly_count(self)
      end
      return total
    else
      listing = Listing.find(self.tour)
      return listing.pv_monthly_count(self)
    end
  end
  
  def favorites_monthly_count(listings)
    if self.tour == Settings.chart_data.tours.all
      total = 0
      listings.each do |listing|
        total += listing.favorites_monthly_count(self)
      end
      return total
    else
      listing = Listing.find(self.tour)
      return listing.favorites_monthly_count(self)
    end
  end
  
  def reservations_monthly_count(listings)
    if self.tour == Settings.chart_data.tours.all
      total = 0
      listings.each do |listing|
        total += listing.reservations_monthly_count(self)
      end
      return total
    else
      listing = Listing.find(self.tour)
      return listing.reservations_monthly_count(self)
    end
  end
  
  def sales_monthly_amount(listings)
    if self.tour == Settings.chart_data.tours.all
      total = 0
      listings.each do |listing|
        total += listing.sales_monthly_amount(self)
      end
      return total
    else
      listing = Listing.find(self.tour)
      return listing.sales_monthly_amount(self)
    end
  end
end