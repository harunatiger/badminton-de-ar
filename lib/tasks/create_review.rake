namespace :create_review do
  desc 'create review'
  task do: :environment do
    begin
      ActiveRecord::Base.transaction do
        p '#2'
        reservation = Reservation.find(110)
        review = ReviewForGuide.create!(guest_id: reservation.guest_id, host_id: reservation.pair_guide_id, reservation_id: reservation.id, listing_id: reservation.listing_id, accuracy: 0, communication: 0, clearliness: 0, location: 0, check_in: 0, cost_performance: 0,total: 5, msg: "Timo is a very nice person, cheerful and attentive. She even learnt my language before meeting me. She helped me a lot and gave me all information needed for a tourist. Definitely recommended!")
        review.re_calc_average
        
        p '#3'
        reservation = Reservation.find(130)
        reservation.update!(pair_guide_id: 116, pair_guide_status: 3)
        ReviewForGuide.create!(guest_id: reservation.guest_id, host_id: reservation.pair_guide_id, reservation_id: reservation.id, listing_id: reservation.listing_id, accuracy: 0, communication: 0, clearliness: 0, location: 0, check_in: 0, cost_performance: 0,total: 5, msg: "Thank you for everything!!  You made my day really special.  You took us to a Japanese vegetable shop first and explained about Japanese vegetables.  Then we went to cooking class.  The teacher knows every detail and meaning of cooking tools, ingredients and Japanese dishes.  I could learn a lot from you and great teacher, Thank you so much! After we had cooking class, Timo guided us to Jyomyo-ji Temple, where we had tea ceremony.  It's really authentic and we could calm ourselves down.  Hope we can meet again :)")
        review.re_calc_average
        
        p '#4'
        reservation = Reservation.find(127)
        ReviewForGuide.create!(guest_id: reservation.guest_id, host_id: reservation.pair_guide_id, reservation_id: reservation.id, listing_id: reservation.listing_id, accuracy: 0, communication: 0, clearliness: 0, location: 0, check_in: 0, cost_performance: 0,total: 5, msg: "Thank you for nice experiences and next time we come to Japan, I will definitely contact you and use TOMODACHI GUIDE again!  Everything was nice in Timo's tour.  She guided us to bamboo forest first and then we went to Jyomyo-ji. This temple was so great that we had real Japanese tea ceremony. Timo, you need to come to Taiwan, I will guide you around my local.  Thank you so much.")
        review.re_calc_average
        
        p '#5'
        reservation = Reservation.find(116)
        ReviewForGuide.create!(guest_id: reservation.guest_id, host_id: reservation.pair_guide_id, reservation_id: reservation.id, listing_id: reservation.listing_id, accuracy: 0, communication: 0, clearliness: 0, location: 0, check_in: 0, cost_performance: 0,total: 5, msg: "Excellent experience in Kamakura! We stayed 2 days in Kamakura and join the tour for 1 day. Atsushi san helped to plan a trip for us in advance. He is a very nice and sincere person. You can feel the passionate to his life and job. You can totally rely on him when you are travelling with him. And all of us have an unforgettable trip in Kamakura.  And thank you for the supporting guide Shiori san. One of us was feeling unwell that day. She helped to take care of her the whole trip. So Atsushi san can concentrate on guiding the tour. Thank you so much, Shiori san! And you reminded us the time when we were still in college.  We have experienced different kind of activities within 7 hours. We started the tour at Kita- Kamakura. We go hiking, visit the shrine, the great buddha and then we have lunch at local restaurant and see the ocean at the last stop.  You don't have to worry what is the direction, what is the next stop, you don't have to see the map. Just enjoy the beautiful scenery. It's very relax for all of us. And when you have questions, Atsushi san can help you a lots.  We recommend Huber for all the tourists from all over the world! Staff are very friendly and helpful. And we wish Huber can expand to more place in Japan. So we can try it every time when we visit to Japan! ")
        review.re_calc_average
        
#         #Rails.root.join("app/assets/images/no-image-1024x640.gif").open
      end
    rescue ActiveRecord::Rollback
    end
  end
end
