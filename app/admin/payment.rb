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
          .filter_by_progress
          .term( @startdate, @enddate )
          .order_by_schedule
          .includes(:reservation)
      Rails.logger.debug('@@@@@@@@@@@@@@@@')
      Rails.logger.debug(@payments.count)
      Rails.logger.debug('@@@@@@@@@@@@@@@@')
      end
    end

    def payment_weekly_report
      if params[:startdate].present? && params[:enddate].present?
        @startdate = Date.parse(params[:startdate])
        @enddate = Date.parse(params[:enddate])
        @payments = Payment.all
          .with_reservation
          .filter_by_progress
          .term( @startdate, @enddate )
          .order_by_schedule
          .includes(:reservation)

        @host_profit_infos = []
        if @payments.present?
          @payments.each do |payment|
            #guide
            guide = User.includes(:profile).find(payment.reservation.host_id)

            #guest
            guest = User.find(payment.reservation.guest_id)

            #listing
            listing = Listing.find(payment.reservation.listing_id)

            #bank information
            host_bank_name = guide.profile.profile_bank.name if guide.profile.profile_bank.present?
            host_bank_branch = guide.profile.profile_bank.branch_name if guide.profile.profile_bank.present?
            if guide.profile.profile_bank.present?
              host_bank_user_name = guide.profile.profile_bank.user_name if guide.profile.profile_bank.present?
            end
            host_bank_account_type = guide.profile.profile_bank.account_type == 0 ? '普通' : '当座'
            host_bank_user_number = guide.profile.profile_bank.number if guide.profile.profile_bank.present?

            #cancel
            if payment.reservation.canceled_after_accepted?
              reservation = payment.reservation
              refund_price = reservation.cancellation_fee
              refund_reason = 'ゲストキャンセル'
            else
              refund_price = ''
              refund_reason = ''
            end

            #campaign code
            if payment.reservation.campaign_id.present?
              campaign = Campaign.find(payment.reservation.campaign_id)
            end
            campaign_code = campaign.code if campaign.present?
            campaign_discount = campaign.discount if campaign.present?

            host_profit_info = {
              #1 決済ID
              id: payment.id,
              #2 ガイドユーザーID
              host_id: payment.reservation.host_id,
              #3 ゲストユーザーID
              guest_id: payment.reservation.guest_id,
              #4 プラン実施日
              schedule: payment.reservation.schedule,
              #5 参加人数
              num_of_people: payment.reservation.num_of_people,
              #6 ガイド銀行名称
              host_bank_name: host_bank_name,
              #7 ガイド銀行支店名
              host_bank_branch: host_bank_branch,
              #8 口座種別
              host_bank_account_type: host_bank_account_type,
              #9 口座名義人
              host_bank_user_name: host_bank_user_name,
              #10 口座番号
              host_bank_user_number: host_bank_user_number,
              #11 ガイドEmailアドレス
              host_email: guide.email,
              #12 ゲストEmailアドレス
              guest_email: guest.email,
              #13 プランID
              listing_id: payment.reservation.listing_id,
              #14 プランタイトル
              listing_title: listing.title,
              #15 ペアガイド基本料金
              listing_price: payment.reservation.price,
              #16 ペアガイド諸経費
              listing_price_other: payment.reservation.price_other,
              #17 諸経費（グループ）
              listing_option_price: payment.reservation.option_price,
              #18 諸経費（ゲスト）
              listing_option_price_per_person: payment.reservation.option_price_per_person,
              #19 決済確定総金額
              reservation_price: payment.amount,
              #20 キャンセル後確定金額
              refund_price: refund_price,
              #21 キャンセル事由
              refund_reason: refund_reason,
              #22 Paypal決済トランID
              payment_transaction_id: payment.transaction_id,
              #23 CPコード
              campaign_code: campaign_code,
              #24 CPディスカウント金額
              campaign_discount: campaign_discount,
              #25 ゲストPaypalID
              guest_paypal_id: payment.payer_id
            }
            @host_profit_infos << host_profit_info
          end
        end
      end
    end
  end
end
