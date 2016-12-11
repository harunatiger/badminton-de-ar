namespace :create_extra_cost do
  desc 'create extra_cost'
  task do: :environment do
    begin
      ActiveRecord::Base.transaction do
        p 'start ListingDetail'
        ListingDetail.all.each do |listing_detail|
          
          if listing_detail.car_option
            if listing_detail.car_rental > 0
              ListingDetailExtraCost.create!(
                listing_detail_id: listing_detail.id,
                description: 'Car',
                price: listing_detail.car_rental,
                for_each: 'team'
              )
            end
            
            if listing_detail.gas > 0
              ListingDetailExtraCost.create!(
                listing_detail_id: listing_detail.id,
                description: 'Gas',
                price: listing_detail.gas,
                for_each: 'team'
              )
            end
            
            if listing_detail.highway > 0
              ListingDetailExtraCost.create!(
                listing_detail_id: listing_detail.id,
                description: 'Expressway',
                price: listing_detail.highway,
                for_each: 'team'
              )
            end
            
            if listing_detail.parking > 0
              ListingDetailExtraCost.create!(
                listing_detail_id: listing_detail.id,
                description: 'Parking',
                price: listing_detail.parking,
                for_each: 'team'
              )
            end
          end
          
          if listing_detail.bicycle_option
            if listing_detail.bicycle_rental > 0
              ListingDetailExtraCost.create!(
                listing_detail_id: listing_detail.id,
                description: 'Bicycle',
                price: listing_detail.bicycle_rental,
                for_each: 'person'
              )
            end
          end
          
          if listing_detail.other_option
            if listing_detail.other_cost > 0
              ListingDetailExtraCost.create!(
                listing_detail_id: listing_detail.id,
                description: 'Other',
                price: listing_detail.other_cost,
                for_each: 'team'
              )
            end
          end
          
        end
        
        fDisabled = GC.enable
        GC.start
        GC.disable if fDisabled
        
        p 'start Reservation'
        Reservation.all.each do |reservation|
          
          if reservation.car_option
            if reservation.car_rental > 0
              ReservationExtraCost.create!(
                reservation_id: reservation.id,
                description: 'Car',
                price: reservation.car_rental,
                for_each: 'team'
              )
            end
            
            if reservation.gas > 0
              ReservationExtraCost.create!(
                reservation_id: reservation.id,
                description: 'Gas',
                price: reservation.gas,
                for_each: 'team'
              )
            end
            
            if reservation.highway > 0
              ReservationExtraCost.create!(
                reservation_id: reservation.id,
                description: 'Expressway',
                price: reservation.highway,
                for_each: 'team'
              )
            end
            
            if reservation.parking > 0
              ReservationExtraCost.create!(
                reservation_id: reservation.id,
                description: 'Parking',
                price: reservation.parking,
                for_each: 'team'
              )
            end
          end
          
          if reservation.bicycle_option
            if reservation.bicycle_rental > 0
              ReservationExtraCost.create!(
                reservation_id: reservation.id,
                description: 'Bicycle',
                price: reservation.bicycle_rental,
                for_each: 'person'
              )
            end
          end
          
          if reservation.other_option
            if reservation.other_cost > 0
              ReservationExtraCost.create!(
                reservation_id: reservation.id,
                description: 'Other',
                price: reservation.other_cost,
                for_each: 'team'
              )
            end
          end
          
        end
      end
    rescue ActiveRecord::Rollback
    end
  end
end
