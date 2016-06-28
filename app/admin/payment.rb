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
          .order_by_schedule
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
          .order_by_schedule
          .includes(:reservation)

        @host_profit_infos = []
        if @payments.present?
          @payments.each do |payment|
            #guide
            guide = User.includes(:profile).find(payment.reservation.host_id)
            guide_name = "#{guide.profile.first_name} #{guide.profile.last_name}"
            
            #support_guide
            support_guide = User.includes(:profile).where(id: payment.reservation.pair_guide_id).first
            support_guide_name = "#{support_guide.profile.first_name} #{support_guide.profile.last_name}" if support_guide.present?

            #guest
            guest = User.find(payment.reservation.guest_id)
            guest_name = "#{guest.profile.first_name} #{guest.profile.last_name}"

            #listing
            listing = Listing.find(payment.reservation.listing_id)

            #bank information
            host_bank_name = guide.profile.profile_bank.name if guide.profile.profile_bank.present?
            host_bank_branch = guide.profile.profile_bank.branch_name if guide.profile.profile_bank.present?
            host_bank_user_name = guide.profile.profile_bank.user_name if guide.profile.profile_bank.present?
            if guide.profile.profile_bank.present?
              host_bank_account_type = guide.profile.profile_bank.account_type == 0 ? '普通' : '当座'
            end
            host_bank_user_number = guide.profile.profile_bank.number if guide.profile.profile_bank.present?

            #fee caliculate
            #guide_amount = payment.reservation.price + payment.reservation.price_for_support + payment.reservation.price_for_both_guides + payment.reservation.option_amount
            guide_amount = payment.reservation.price + payment.reservation.price_for_support + payment.reservation.option_amount
            service_fee_guest = (guide_amount * 0.145).ceil

            #campaign code
            if payment.reservation.campaign_id.present?
              campaign = Campaign.find(payment.reservation.campaign_id)
            end
            if campaign.present?
              campaign_code = campaign.code
              campaign_discount = campaign.discount
              settlement_amount = guide_amount + service_fee_guest - campaign_discount
            else
              settlement_amount = guide_amount + service_fee_guest
            end

            #cancel
            reservation = payment.reservation
            cancel_date = payment.reservation.canceled_after_accepted? ? payment.reservation.updated_at : ''
            #{ default: 0, guide: 1, guest_before_weeks: 2, guest_before_days: 3, guest_less_than_days: 4}
            if reservation.default?
              refund_reason = ''
              fixed_amount = guide_amount * 1
              guest_refund = settlement_amount * 0
            elsif reservation.guide?
              refund_reason = 'ガイドキャンセル'
              fixed_amount = guide_amount * 0
              guest_refund = settlement_amount * 1
            elsif reservation.guest_before_weeks?
              refund_reason = 'ゲストキャンセルA'
              fixed_amount = guide_amount * 0
              guest_refund = settlement_amount * 1
            elsif reservation.guest_before_days?
              refund_reason = 'ゲストキャンセルB'
              fixed_amount = (guide_amount * 0.5).ceil
              guest_refund = (settlement_amount * 0.5).ceil
            elsif reservation.guest_less_than_days?
              refund_reason = 'ゲストキャンセルC'
              fixed_amount = guide_amount * 1
              guest_refund = settlement_amount * 0
            end

            service_fee_guide = (fixed_amount * 0.145).ceil
            guide_payment = (payment.reservation.price + payment.reservation.option_amount) - ((fixed_amount * 0.145) / 2).ceil
            support_guide_payment = payment.reservation.price_for_support - ((fixed_amount * 0.145) / 2).ceil

            if !reservation.default?
              refund_complete = 'NG' if payment.refund_disabled?
            end

            host_profit_info = {
              #決済ID
              id: payment.id,
              #メインガイドID
              host_id: guide.profile.id,
              #メインガイド名
              host_name: guide_name,
              #サポートガイドID
              support_guide_id: support_guide.present? ? support_guide.profile.id : '',
              #サポートガイド名
              support_guide_name: support_guide_name,
              #ゲストID
              guest_id: guest.profile.id,
              #ゲスト名
              guest_name: guest_name,
              #プラン実施日
              schedule: payment.reservation.schedule,
              #キャンセル日
              cancel_date: cancel_date,
              #参加人数
              num_of_people: payment.reservation.num_of_people,
              #ガイド銀行名称
              host_bank_name: host_bank_name,
              #ガイド銀行支店名
              host_bank_branch: host_bank_branch,
              #口座種別
              host_bank_account_type: host_bank_account_type,
              #口座名義人
              host_bank_user_name: host_bank_user_name,
              #口座番号
              host_bank_user_number: host_bank_user_number,
              #ガイドEmailアドレス
              host_email: guide.email,
              #ゲストEmailアドレス
              guest_email: guest.email,
              #プランID
              listing_id: payment.reservation.listing_id,
              #プランタイトル
              listing_title: listing.title,
              #ガイドの収入
              listing_price: payment.reservation.price,
              #サポートメンバーの収入
              listing_price_for_support: payment.reservation.price_for_support,
              #2人にかかる費用
              #listing_price_for_both_guides: payment.reservation.price_for_both_guides,
              #オプション費用
              listing_option_amount: payment.reservation.option_amount,
              #ガイド料金
              guide_amount: guide_amount,
              #サービス料金（ゲスト）
              service_fee_guest: service_fee_guest,
              #CPディスカウント金額
              campaign_discount: campaign_discount,
              #決済金額
              reservation_price: settlement_amount,
              #キャンセル事由
              refund_reason: refund_reason,
              #確定ガイド料金
              fixed_amount: fixed_amount,
              #サービス料金（ガイド）
              service_fee_guide: service_fee_guide,
              #メインガイド支払
              guide_payment: guide_payment,
              #サポートガイド支払
              support_guide_payment: support_guide_payment,
              #ゲスト返金
              guest_refund: guest_refund,
              #自動返金
              refund_complete: refund_complete,
              #Paypal決済トランID
              payment_transaction_id: payment.transaction_id,
              #CPコード
              campaign_code: campaign_code,
              #ゲストPaypalID
              guest_paypal_id: payment.payer_id,
              #ReservationID
              reservation_id: payment.reservation_id
            }
            @host_profit_infos << host_profit_info
          end
        end
      end
    end
  end
end
