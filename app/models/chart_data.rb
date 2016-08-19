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
            result.push([date.day.to_s,pv, Reservation.count_on_the_day(listings, date)])
          end
        elsif self.data == Settings.chart_data.data.favorites
          (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
            favorites = FavoriteListing.listings_favorites(listings).created_when(date.beginning_of_day, date.end_of_day).count
            result.push([date.day.to_s,favorites, Reservation.count_on_the_day(listings, date)])
          end
        elsif self.data == Settings.chart_data.data.sales
          (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
            sales = Reservation.seles_daily(listings, date)
            result.push([date.day.to_s,sales, Reservation.count_on_the_day(listings, date)])
          end
        end
      else

        listing = Listing.find(self.tour)
        if self.benchmark.present?
          pickup = Pickup.find(self.benchmark.to_i)
          if pickup.pickup_tag?
            benchmark_listings = pickup.benchmark_listings_by_listing_images
          else
            benchmark_listings = pickup.benchmark_listings
          end
        end

        if self.data == Settings.chart_data.data.pv
          if self.benchmark.present?
            (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
              pv = BrowsingHistory.where(listing_id: listing.id).viewed_when(date.beginning_of_day, date.end_of_day).count
              benchmark_pv = BrowsingHistory.listings_pv(benchmark_listings).viewed_when(date.beginning_of_day, date.end_of_day).count
              result.push([date.day.to_s, pv,listing.reservations_daily_count(date), benchmark_pv / benchmark_listings.count])
            end
          else
            (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
              pv = BrowsingHistory.where(listing_id: listing.id).viewed_when(date.beginning_of_day, date.end_of_day).count
              result.push([date.day.to_s,pv,listing.reservations_daily_count(date)])
            end
          end
        elsif self.data == Settings.chart_data.data.favorites
          if self.benchmark.present?
            (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
              favorites = FavoriteListing.where(listing_id: listing.id).created_when(date.beginning_of_day, date.end_of_day).count
              benchmark_favorites = FavoriteListing.listings_favorites(benchmark_listings).created_when(date.beginning_of_day, date.end_of_day).count
              result.push([date.day.to_s,favorites, listing.reservations_daily_count(date), benchmark_favorites / benchmark_listings.count])
            end
          else
            (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
              favorites = FavoriteListing.where(listing_id: listing.id).created_when(date.beginning_of_day, date.end_of_day).count
              result.push([date.day.to_s,favorites,listing.reservations_daily_count(date)])
            end
          end
        elsif self.data == Settings.chart_data.data.sales
          if self.benchmark.present?
            (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
              sales = listing.sales_daily_amount(date)
              benchmark_sales = Reservation.seles_daily(benchmark_listings, date)
              result.push([date.day.to_s,sales,listing.reservations_daily_count(date), benchmark_sales / benchmark_listings.count])
            end
          else
            (Date.parse(self.day.beginning_of_month.to_s)..Date.parse(self.day.end_of_month.to_s)).each do |date|
              sales = listing.sales_daily_amount(date)
              result.push([date.day.to_s,sales,listing.reservations_daily_count(date)])
            end
          end
        end
      end
    end
    
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'date' )
    data_table.new_column('number', 'value')
    data_table.new_column('number', 'reservation')
    data_table.new_column('number', 'average') if self.benchmark.present?
    data_table.add_rows(result) if result.present?
    
    option = {hAxis: {title: 'Day'}, interpolateNulls: true, height: 400, legend: { position: 'top'}}
    if self.benchmark.present?
      option.store("series", { 1 => { type: "scatter" }, 2 => { type: "line" } })
    else
      option.store("series", { 1 => { type: "scatter" } })
    end
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
  
  def pv_whole_count(listings)
    if self.tour == Settings.chart_data.tours.all
      return BrowsingHistory.where(listing_id: listings.ids).count
    else
      return BrowsingHistory.where(listing_id: self.tour.to_i).count
    end
  end
  
  def favorites_whole_count(listings)
    if self.tour == Settings.chart_data.tours.all
      return FavoriteListing.where(listing_id: listings.ids).count
    else
      return FavoriteListing.where(listing_id: self.tour.to_i).count
    end
  end
  
  def reservations_whole_count(listings)
    if self.tour == Settings.chart_data.tours.all
      return Reservation.where(listing_id: listings.ids).finished_before_yesterday.need_to_guide_pay.count
    else
      return Reservation.where(listing_id: self.tour.to_i).finished_before_yesterday.need_to_guide_pay.count
    end
  end
  
  def sales_whole_amount(listings)
    if self.tour == Settings.chart_data.tours.all
      reservations = Reservation.where(listing_id: listings.ids).finished_before_yesterday.need_to_guide_pay
    else
      reservations = Reservation.where(listing_id: self.tour.to_i).finished_before_yesterday.need_to_guide_pay
    end
    total_sales = 0
    reservations.each do |reservation|
      total_sales += reservation.main_guide_payment
    end
    total_sales
  end
end