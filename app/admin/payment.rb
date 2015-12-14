ActiveAdmin.register_page "Payment" do

  sidebar 'filter' do
    render 'filter'
  end

  content do
    render 'index'
  end

  controller do
    def index
      if params[:startdate].present? && params[:enddate].present?
        @startdate = Date.parse(params[:startdate])
        @enddate = Date.parse(params[:enddate])
        @payments = Payment.all
          .with_reservation
          .term( @startdate, @enddate )
          .includes(:reservation)
      end
    end

    def payment_weekly_report
      if params[:startdate].present? && params[:enddate].present?
        @startdate = Date.parse(params[:startdate])
        @enddate = Date.parse(params[:enddate])
        @payments = Payment.all
          .with_reservation
          .term( @startdate, @enddate )
          .includes(:reservation)

        @host_profit_infos = []

        @payments.each do |payment|
          if payment.reservation.canceled?
            remarks = 'Canceled : Refund Rate ' + payment.reservation.refund_rate.to_s + '%'
          else
            remarks = ''
          end

          host_profit_info = {
            id: payment.reservation.id,
            host_id: payment.reservation.host_id,
            guest_id: payment.reservation.guest_id,
            listing_id: payment.reservation.listing_id,
            schedule: payment.reservation.schedule,
            num_of_people: payment.reservation.num_of_people,
            msg: payment.reservation.msg,
            progress: payment.reservation.progress,
            reason: payment.reservation.reason,
            review_mail_sent_at: payment.reservation.review_mail_sent_at,
            review_expiration_date: payment.reservation.review_expiration_date,
            review_landed_at: payment.reservation.review_landed_at,
            reviewed_at: payment.reservation.reviewed_at,
            reply_mail_sent_at: payment.reservation.reply_mail_sent_at,
            reply_landed_at: payment.reservation.reply_landed_at,
            replied_at: payment.reservation.replied_at,
            review_opened_at: payment.reservation.review_opened_at,
            time_required: payment.reservation.time_required,
            price: payment.reservation.price,
            option_price: payment.reservation.option_price,
            place: payment.reservation.place,
            description: payment.reservation.description,
            schedule_end: payment.reservation.schedule_end,
            option_price_per_person: payment.reservation.option_price_per_person,
            place_memo: payment.reservation.place_memo,
            campaign_id: payment.reservation.campaign_id,
            price_other: payment.reservation.price_other,
            refund_rate:  payment.reservation.refund_rate,
            created_at: payment.reservation.created_at,
            updated_at: payment.reservation.updated_at,
            remarks: remarks
          }
          @host_profit_infos << host_profit_info
        end
      end
    end
  end
end
