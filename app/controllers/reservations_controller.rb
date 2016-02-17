class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:show, :update, :destroy]
  include Payments

  def create
    if params[:request].present? and !current_user.already_authrized
      if profile_identity = ProfileIdentity.where(user_id: current_user.id, profile_id: current_user.profile.id).first
        return redirect_to edit_profile_profile_identity_path(profile_id: current_user.profile.id, id:profile_identity.id), alert: Settings.reservation.save.failure.not_authorized_yet
      else
        return redirect_to new_profile_profile_identity_path(current_user.profile), alert: Settings.reservation.save.failure.not_authorized_yet
      end
    end

    reservation_before = Reservation.latest_reservation(reservation_params['guest_id'], reservation_params['host_id'])
    reservation = Reservation.requested_reservation(reservation_params['guest_id'], reservation_params['host_id'])
    reservation.update(progress: 'rejected') if reservation.present?

    para = reservation_params
    para['progress'] = 'holded' if params[:save]
    if params[:reserve]
      para['schedule_date'] = Date.strptime(para['schedule_date'], '%m/%d/%Y').to_s
      para['schedule_end'] = para['schedule_date']
    end
    para['campaign_id'] = nil if reservation_before and reservation_before.accepted?

    if reservation_before and reservation_before.holded?
      @reservation = reservation_before
      result = @reservation.update(para)
    else
      @reservation = Reservation.new(para)
      result = @reservation.save
    end

    respond_to do |format|
      if result
        ngevent_params = Hash[
          'reservation_id' => @reservation.id,
          'listing_id' => @reservation.listing_id,
          'user_id' => @reservation.host_id,
          'guest_id' => @reservation.guest_id,
          'start' => @reservation.schedule,
          'end' => @reservation.schedule_end,
          'end_bk' => @reservation.schedule_end,
          'mode' => 2,  # 1:reservation_mode,  2:requet_mode
          'active' => 1,# 0:no actice
          'color' => 'red'
          ]

        unless params[:save]
          Ngevent.change_date(ngevent_params, @reservation.id)
          if params[:reserve]
            ReservationMailer.send_new_reservation_notification(@reservation).deliver_now!
            ReservationMailer.send_new_reservation_notification_to_admin(@reservation).deliver_now!
          else
            ReservationMailer.send_new_guide_detail_notification(@reservation).deliver_now!
          end

          msg_params = Hash[
            'reservation_id' => @reservation.id,
            'listing_id' => @reservation.listing_id,
            'from_user_id' => params[:reserve].present? ? @reservation.guest_id : @reservation.host_id,
            'to_user_id' => params[:reserve].present? ? @reservation.host_id : @reservation.guest_id,
            'progress' => @reservation.progress,
            'schedule' => @reservation.schedule,
            'message_thread_id' => @reservation.message_thread_id,
            'content' => params[:reserve].present? ? Settings.reservation.msg.reserve : Settings.reservation.msg.request,
            'reply_from_host' => @reservation.host_id == current_user.id ? 1 : 0
          ]
          if @reservation.message_thread_id
            mt_obj = MessageThread.find(@reservation.message_thread_id)
            mt_obj.update(reply_from_host: msg_params['reply_from_host'],first_message: 0)
          else
            if id = MessageThread.exists_thread?(msg_params)
              mt_obj = MessageThread.find(id)
              mt_obj.update(reply_from_host: msg_params['reply_from_host'],first_message: 0)
            else
              mt_obj = MessageThread.create_thread(msg_params)
            end
            @reservation.message_thread_id = mt_obj.id
          end
          result = Message.send_message(mt_obj, msg_params)
        else
          result = true
        end

        if result
          format.html { redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.reservation.save.success }
          format.json { render :show, status: :created, location: @reservation }
        else
          format.html { redirect_to message_thread_path(@reservation.message_thread_id), alert: Settings.reservation.save.failure.no_date }
          format.json { render json: @reservation.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @reservation.message_thread_id ? message_thread_path(@reservation.message_thread_id) : listing_path(@reservation.listing_id), alert: Settings.reservation.save.failure.no_date }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm
    @reservation = Reservation.find(session[:reservation_id])
    @reservation.campaign = Campaign.find(session[:campaign_id]) if session[:campaign_id].present?
    details = set_details(params[:token])
    if details.success?
      @payment = @reservation.payment.present? ? @reservation.payment : Payment.create(reservation_id: @reservation.id)
      @payment.update(
        token: details.token,
        payer_id: details.payer_id,
        payers_status: details.params['payer_status'],
        amount: details.params['order_total'],
        currency_code: details.params['order_total_currency_id'],
        email: details.params['payer'],
        first_name: details.params['first_name'],
        last_name: details.params['last_name'],
        country_code: details.params['country'],
        payment_status: 'Confirmed'
      )
    else
      respond_to do |format|
        format.html { redirect_to message_thread_path(session[:message_thread_id]), alert: Settings.reservation.save.failure.paypal_access_failure + ' error：' + details.params['error_codes'] + ' ' + details.params['message']}
      end
    end
    @listing = Listing.find(@reservation.listing_id)
  end

  def cancel
    message_thread_id = session[:message_thread_id]
    session[:reservation_id] = nil
    session[:message_thread_id] = nil
    session[:campaign_id] = nil
    respond_to do |format|
      format.html { redirect_to message_thread_path(message_thread_id), alert: Settings.reservation.save.failure.paypal_canceled}
    end
  end

  def update
    if params[:accept].present? and !current_user.already_authrized
      if profile_identity = ProfileIdentity.where(user_id: current_user.id, profile_id: current_user.profile.id).first
        return redirect_to edit_profile_profile_identity_path(profile_id: current_user.profile.id, id:profile_identity.id), alert: Settings.reservation.accept.failure.not_authorized_yet
      else
        return redirect_to new_profile_profile_identity_path(current_user.profile), alert: Settings.reservation.accept.failure.not_authorized_yet
      end
    end
    para = reservation_params
    message_thread_id = para[:message_thread_id].present? ? para[:message_thread_id] : session[:message_thread_id]
    session[:message_thread_id] = nil
    payment = @reservation.payment
    if params[:cancel]
      if payment.present? and payment.payment_status == 'Completed' and payment.cancel_available(@reservation)
        response = refund(payment,@reservation)
        unless response.success?
          respond_to do |format|
            format.html { return redirect_to message_thread_path(message_thread_id), alert: Settings.reservation.save.failure.paypal_refund_failure + ' error：' + response.params['error_codes'] + ' ' + response.params['message']}
            format.json { return render :show, status: :ok, location: @reservation }
            format.js { @status = 'failure' }
          end
        else
          payment.transaction_id = response.params['refund_transaction_id']
          payment.refund_date = response.params['timestamp']
          payment.payment_status = 'Refunded'
          payment.save

          if @reservation.campaign.present? and @reservation.before_weeks?
            current_user.campaigns = current_user.campaigns.where.not(id: @reservation.campaign_id)
          end
        end
      end
      msg = Settings.reservation.msg.canceled
      if @reservation.before_weeks?
        para[:refund_rate] = Settings.payment.refunds.before_weeks_rate
      elsif @reservation.before_days?
        para[:refund_rate] = Settings.payment.refunds.before_days_rate
      end

      para[:progress] = @reservation.accepted? ? 6 : 1
    elsif params[:accept]
      session[:message_thread_id] = message_thread_id
      session[:reservation_id] = @reservation.id

      if para[:campaign_code].present?
        campaign = Campaign.where(code: para[:campaign_code]).first
        if campaign.blank?
          return redirect_to message_thread_path(message_thread_id), alert: Settings.reservation.save.failure.invalid_campaign_code
        elsif campaign.users.exists?(current_user)
          return redirect_to message_thread_path(message_thread_id), alert: Settings.reservation.save.failure.used_campaign_code
        else
          @reservation.campaign = campaign
          session[:campaign_id] = campaign.id
        end
      end
      return checkout(@reservation) if @reservation.amount_for_campaign > 0
      para[:progress] = 3
      msg = Settings.reservation.msg.accepted
      UserCampaign.create(user_id: current_user.id, campaign_id: campaign.id) if campaign.present?
      Payment.create(reservation_id: @reservation.id) if @reservation.payment.blank?
      session[:campaign_id] = nil
    elsif params[:payment]
      payment.reservation.campaign_id = session[:campaign_id] if session[:campaign_id]
      session[:campaign_id] = nil
      response = purchase(payment)
      if response.success?
        payment.transaction_id = response.params['transaction_id']
        payment.transaction_date = response.params['payment_date']
        payment.payment_status = response.params['payment_status']
        payment.save

        UserCampaign.create(user_id: current_user.id, campaign_id: para[:campaign_id]) if para[:campaign_id].present?
      else
        respond_to do |format|
          format.html { return redirect_to message_thread_path(message_thread_id), alert: Settings.reservation.save.failure.paypal_payment_failure + ' error：' + response.params['error_codes'] + ' ' + response.params['message']}
          format.json { return render :show, status: :ok, location: @reservation }
        end
      end
      para[:progress] = 3
      msg = Settings.reservation.msg.accepted
    elsif params[:payment_cancel]
      respond_to do |format|
        format.html { return redirect_to message_thread_path(message_thread_id), alert: Settings.reservation.save.failure.paypal_canceled }
        format.json { return render :show, status: :ok, location: @reservation }
      end
    end

    respond_to do |format|
      if @reservation.update(para)

        @ng_event = Ngevent.find_by(reservation_id: @reservation.id)
        if @reservation.progress == "accepted"
          @ng_event.update_attributes({:active => 1, :mode => 1})
        elsif @reservation.progress == "requested"
          @ng_event.update_attributes({:active => 1, :mode => 2})
        else
          @ng_event.update_attribute(:active, 0)
        end
        unless @ng_event.save
          format.html { return redirect_to message_thread_path(message_thread_id), alert: Settings.message.save.failure }
          format.json { return render json: { success: false } } if request.xhr?
          format.js { @status = 'failure' }
        end

        ReservationMailer.send_update_reservation_notification(@reservation, @reservation.guest_id).deliver_now!
        if @reservation.canceled_after_accepted?
          ReservationMailer.send_cancel_mail_to_owner(@reservation).deliver_now!
          note = Settings.reservation.update.cancel_success
        end

        if @reservation.host_id == current_user.id
          reply_from_host = 1
        else
          if msg == Settings.reservation.msg.accepted || msg == Settings.reservation.msg.canceled
            reply_from_host = 1
          else
            reply_from_host = 0
          end
        end

        msg_params = Hash[
          'reservation_id' => @reservation.id,
          'listing_id' => @reservation.listing_id,
          'from_user_id' => @reservation.guest_id,
          'to_user_id' => @reservation.host_id,
          'progress' => @reservation.progress,
          'schedule' => @reservation.schedule,
          'message_thread_id' => message_thread_id,
          'content' => msg,
          'reply_from_host' => reply_from_host
        ]

        mt_obj = MessageThread.find(message_thread_id)
        mt_obj.update(reply_from_host: msg_params['reply_from_host'],first_message: 0)

        if Message.send_message(mt_obj, msg_params)
          format.html { redirect_to message_thread_path(message_thread_id), notice: note.present? ? note : Settings.reservation.update.success }
          format.json { render :show, status: :ok, location: @reservation }
          format.js { @status = 'success' }
        else
          format.html { redirect_to message_thread_path(message_thread_id) }
          format.json { render json: @reservation.errors, status: :unprocessable_entity }
          format.js { @status = 'failure' }
        end
      else
        format.html { redirect_to message_thread_path(message_thread_id), alert: Settings.reservation.update.failure }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
        format.js { @status = 'failure' }
      end
    end
  end

  def set_reservation_by_listing
    if request.xhr?
      listing = Listing.find(params[:listing_id])
      @reservation = params[:reservation_id].present? ? Reservation.find(params[:reservation_id]) : Reservation.new
      @reservation.listing_id = listing.id
      @reservation.time_required = listing.listing_detail.time_required
      @reservation.price = listing.listing_detail.price
      @reservation.price_for_support = listing.listing_detail.price_for_support
      @reservation.price_for_both_guides = listing.listing_detail.price_for_both_guides
      @reservation.place = listing.listing_detail.place
      @reservation.place_memo = listing.listing_detail.place_memo
      @reservation.space_option = listing.listing_detail.space_option
      @reservation.car_option = listing.listing_detail.car_option
      @reservation.space_options.each do |option|
        @reservation[option] = listing.listing_detail[option]
      end
      @reservation.car_options.each do |option|
        @reservation[option] = listing.listing_detail[option]
      end
      @reservation.guests_cost = listing.listing_detail.guests_cost
      @reservation.included_guests_cost = listing.listing_detail.included_guests_cost

      @listings = User.find(current_user.id).listings.opened.without_soft_destroyed
      render partial: 'message_threads/reservation_detail_form', locals: {reservation: @reservation}
    end
  end

  def set_reservation_default
    if request.xhr?
      @reservation = params[:reservation_id].present? ? Reservation.find(params[:reservation_id]) : Reservation.new
      @listings = User.find(current_user.id).listings.opened.without_soft_destroyed
      render partial: 'message_threads/reservation_detail_form', locals: {reservation: @reservation}
    end
  end

  def set_ngday_reservation_by_listing
    if request.xhr?
      listing = Listing.find(params[:listing_id])
      #@reservation = params[:reservation_id].present? ? Reservation.find(params[:reservation_id]) : Reservation.new
      #@reservation.listing_id = listing.id
      #ngdates = Ngevent.get_ngdates(@reservation)
      #ngweeks = NgeventWeek.where(listing_id: listing.id).pluck(:dow)
      user_id = listing.user_id
      ngdates = Ngevent.get_ngdates(user_id)
      ngweeks = NgeventWeek.where(user_id: user_id).pluck(:dow)
      render json: { ngdates: ngdates, ngweeks: ngweeks}
    end
  end

  def set_ngday_reservation_default
    if request.xhr?
      @reservation = params[:reservation_id].present? ? Reservation.find(params[:reservation_id]) : Reservation.new
      #ngdates = Ngevent.get_ngdates(@reservation)
      #ngweeks = NgeventWeek.where(listing_id: @reservation.try('listing_id')).pluck(:dow)
      user_id = @reservation.try('host_id')
      ngdates = Ngevent.get_ngdates(user_id)
      ngweeks = NgeventWeek.where(user_id: user_id).pluck(:dow)
      render json: { ngdates: ngdates, ngweeks: ngweeks}
    end
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:listing_id, :host_id, :guest_id, :num_of_people, :content, :progress, :reason,:time_required, :price, :price_for_support, :price_for_both_guides, :space_option, :car_option, :space_rental, :car_option, :car_rental, :gas, :highway, :parking, :guests_cost, :included_guests_cost, Reservation::REGISTRABLE_ATTRIBUTES, :place, :place_memo, :description, :message_thread_id, :schedule_end, :campaign_id, :campaign_code)
    end

    def checkout(reservation)
      respond_to do |format|
        setup_response = set_checkout(reservation)
        if reservation.valid? and setup_response.success?
          format.html {redirect_to gateway.redirect_url_for(setup_response.token)}
        else
          message_thread_id = session[:message_thread_id]
          session[:message_thread_id] = nil
          p setup_response
          format.html { redirect_to message_thread_path(message_thread_id), alert: setup_response.success? ? Settings.reservation.save.failure.no_date : Settings.reservation.save.failure.paypal_access_failure + ' error：' + setup_response.params['error_codes'] + ' ' + setup_response.params['message']}
          format.json { render json: reservation.errors, status: :unprocessable_entity }
        end
      end
    end
end
