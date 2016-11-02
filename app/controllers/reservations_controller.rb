class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:update]
  before_action :check_profile_identity, only: [:update]
  before_action :check_campaign_code, only: [:update]
  include Payments
  include RequestBooking

  # request button of the listing view (guest)
  def create
    return save if params[:save]
    return offer if params[:offer]

    respond_to do |format|
      if message = RequestBooking.request_booking(reservation_params)
        format.html { redirect_to message_thread_path(message.message_thread_id), notice: Settings.reservation.save.success }
      else
        format.html { redirect_to listing_path(@reservation.listing_id), alert: Settings.reservation.save.failure.no_date }
      end
    end
  end

  def update
    # save button of the message thread (guide)
    return save if params[:save]
    # offer button of the message thread (guide)
    return offer if params[:offer]
    # cancel offer button of the message thread (guide)
    return cancel_offer if params[:cancel_offer]
    # cancel button of the message thread (guest)
    return cancel if params[:cancel]
    # confirm button of the message thread (guest)
    return confirm if params[:confirm]
    # cancel button of the paypal authorization view or the payment confirmation view
    return cancel_payment if params[:cancel_payment]
    # purchase button of the payment confirmation view
    return purchase if params[:purchase]
    # cancel button of the dashboard
    return canceled_after_accepted if params[:canceled_after_accepted]
    # offer button of the pair guide thread
    return offer_pair_guide if params[:offer_pair_guide]
    # cancel button of the pair guide thread
    return cancel_pair_guide if params[:cancel_pair_guide]
    # accept button of the pair guide thread
    return accept_pair_guide if params[:accept_pair_guide]
    # cancel pair guide button of the dashboard
    return cancel_pair_guide_from_dashboard if params[:cancel_pair_guide_from_dashboard]
  end

  # save button of the message thread (guide)
  def save
    @reservation = Reservation.new if @reservation.blank?
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.reservation.save.success }
      else
        format.html { redirect_to message_thread_path(reservation_params[:message_thread_id]), alert: Settings.reservation.save.failure.no_date }
      end
    end
  end

  # offer button of the message thread (guide)
  def offer
    @reservation = Reservation.new if @reservation.blank?
    respond_to do |format|
      if @reservation.update(reservation_params)
        Ngevent.offer(@reservation)
        ReservationMailer.send_new_guide_detail_notification(@reservation).deliver_now!
        ReservationMailer.send_requested_mail_to_owner(@reservation).deliver_now!
        message = Message.send_reservation_message_to_guest(@reservation, Settings.reservation.msg.request)

        if message
          format.html { redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.reservation.update.success }
        else
          format.html { redirect_to message_thread_path(reservation_params[:message_thread_id]) }
        end
      else
        format.html { redirect_to message_thread_path(message_thread_id), alert: Settings.reservation.update.failure }
      end
    end
  end
  
  def cancel_offer
    @reservation.under_construction!
    respond_to do |format|
      Ngevent.cancel(@reservation)
      Message.send_reservation_message_to_guest(@reservation, Settings.reservation.msg.canceled_offer_en)
      ReservationMailer.cancel_offer_notification(@reservation).deliver_now!
      format.html { redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.reservation.update.success }
    end
  end

  # cancel button of the message thread (guest)
  def cancel
    respond_to do |format|
      if @reservation.update(reservation_params)
        @reservation.canceled!
        Ngevent.cancel(@reservation)
        ReservationMailer.send_update_reservation_notification(@reservation, @reservation.guest_id).deliver_now!
        message = Message.send_reservation_message_to_host(@reservation, Settings.reservation.msg.canceled, false)

        format.html { redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.reservation.save.success }
      else
        format.html { redirect_to message_thread_path(reservation_params[:message_thread_id]), alert: Settings.reservation.save.failure.no_date }
      end
    end
  end

  # confirm button of the message thread (guest)
  def confirm
    session[:message_thread_id] = reservation_params[:message_thread_id]
    session[:reservation_id] = @reservation.id
    return checkout(@reservation) if @reservation.amount_for_campaign > 0

    # if @reservation.amount_for_campaign <= 0
    UserCampaign.create(user_id: current_user.id, campaign_id: @campaign.id) if @campaign.present?
    Payment.create(reservation_id: @reservation.id, currency_code: session[:currency_code], exchange_rate: session[:rate]) if @reservation.payment.blank?
    session[:campaign_id] = nil

    respond_to do |format|
      if @reservation.update(reservation_params)
        @reservation.accepted!

        Ngevent.accept(@reservation)

        ReservationMailer.send_update_reservation_notification(@reservation, @reservation.guest_id).deliver_now!
        ReservationMailer.send_accepted_mail_to_owner(@reservation).deliver_now!
        message = Message.send_reservation_message_to_host(@reservation, Settings.reservation.msg.accepted, false)

        format.html { redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.reservation.update.success }
      else
        format.html { redirect_to message_thread_path(@reservation.message_thread_id), alert: Settings.reservation.update.failure }
      end
    end
  end

  # cancel button of the paypal authorization view or the payment confirmation view
  def cancel_payment
    message_thread_id = session[:message_thread_id]
    session[:reservation_id] = nil
    session[:message_thread_id] = nil
    session[:campaign_id] = nil
    respond_to do |format|
      format.html { redirect_to message_thread_path(message_thread_id), alert: Settings.reservation.save.failure.paypal_canceled}
    end
  end

  # purchase button of the payment confirmation view
  def purchase
    message_thread_id = session[:message_thread_id]
    session[:message_thread_id] = nil
    @reservation.message_thread_id = message_thread_id
    @reservation.campaign = Campaign.find(reservation_params[:campaign_id]) if reservation_params[:campaign_id].present?
    response = do_purchase(@reservation.payment)
    unless response.success?
      respond_to do |format|
        format.html { return redirect_to message_thread_path(message_thread_id), alert: Settings.reservation.save.failure.paypal_payment_failure + ' error：' + response.params['error_codes'] + ' ' + response.params['message']}
      end
    end

    @reservation.set_purchase(response)
    @reservation.accepted!
    UserCampaign.create(user_id: current_user.id, campaign_id: @reservation.campaign_id) if @reservation.campaign_id.present?
    Ngevent.accept(@reservation)
    ReservationMailer.send_update_reservation_notification(@reservation, @reservation.guest_id).deliver_now!
    ReservationMailer.send_accepted_mail_to_owner(@reservation).deliver_now!
    message = Message.send_reservation_message_to_host(@reservation, Settings.reservation.msg.accepted, false)
    respond_to do |format|
      format.html { redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.reservation.update.success }
    end
  end

  def canceled_after_accepted
    #@booking_index = params[:count] if params[:count].present? #for dashboard/_reservation_item_as_host
    payment = @reservation.payment

    if payment.completed?
      if payment.cancel_available(@reservation)
        if @reservation.host_id == current_user.id
          response = refund_full(payment)
        elsif
          response = refund(payment,@reservation)
        end
      elsif @reservation.before_days?
        payment.refund_disabled!
      end
    end

    if response.present? and !response.success?
      respond_to do |format|
        format.js { @status = 'failure' }
      end
    else
      @reservation.set_refund(response, current_user) if response.present?
      @reservation.set_cancel_by(current_user) if response.blank?

      if @reservation.guide? or @reservation.before_weeks?
        Campaign.remove_used_code(@reservation)
      end

      Ngevent.cancel(@reservation)
      mail_to_user = @reservation.guide? ? @reservation.host_id : @reservation.guest_id
      ReservationMailer.send_cancel_mail_to_owner(@reservation).deliver_now!
      ReservationMailer.send_update_reservation_notification(@reservation, mail_to_user).deliver_now!
      PairGuideMailer.send_update_pair_guide_notification(current_user, User.find(@reservation.pair_guide_id), @reservation.message_thread_id, Settings.reservation.pair_guide_status.canceled).deliver_now! if @reservation.pg_completion?

      if @reservation.host_id == current_user.id
        Message.send_reservation_message_to_guest(@reservation, Settings.reservation.msg.canceled)
        Message.send_pair_guide_message(PairGuideThread.existed_pair_guide_thread(@reservation.id, @reservation.pair_guide_id), Settings.reservation.msg.cancel_pair_guide_from_dashboard, current_user.id, @reservation.pair_guide_id) if @reservation.pg_completion?
      else
        Message.send_reservation_message_to_host(@reservation, Settings.reservation.msg.canceled, false)
      end

      respond_to do |format|
        format.js { @status = 'success' }
      end
    end
  end

  # payment confirmation after paypal authorization
  def confirm_payment
    @reservation = Reservation.find(session[:reservation_id])
    @reservation.campaign = Campaign.find(session[:campaign_id]) if session[:campaign_id].present?
    session[:campaign_id] = nil
    session[:reservation_id] = nil
    details = set_details(params[:token])
    if details.success?
      @payment = @reservation.set_details(details, session[:rate])
      @listing = Listing.find(@reservation.listing_id)
    else
      respond_to do |format|
        format.html { redirect_to message_thread_path(session[:message_thread_id]), alert: Settings.reservation.save.failure.paypal_access_failure + ' error：' + details.params['error_codes'] + ' ' + details.params['message']}
      end
    end
  end
  
  def offer_pair_guide
    if @reservation.update(pair_guide_params)
      message = Message.send_pair_guide_message(@reservation.message_thread_id, Settings.reservation.msg.pair_guide_offer, current_user.id, @reservation.pair_guide_id)
      PairGuideMailer.send_update_pair_guide_notification(current_user, User.find(@reservation.pair_guide_id), @reservation.message_thread_id, Settings.reservation.pair_guide_status.offer).deliver_now!
      redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.reservation.pair_guide.success
    else
      redirect_to message_thread_path(pair_guide_params[:message_thread_id]), alert: Settings.reservation.pair_guide.failure
    end
  end
  
  def cancel_pair_guide
    pair_guide_id = @reservation.pair_guide_id
    if @reservation.update(pair_guide_params)
      if current_user.id == @reservation.host_id
        to_user_id = pair_guide_id
      else
        to_user_id = @reservation.host_id
      end
      message = Message.send_pair_guide_message(@reservation.message_thread_id, Settings.reservation.msg.pair_guide_cancel, current_user.id, to_user_id)
      @reservation.pg_under_construction!
      PairGuideMailer.send_update_pair_guide_notification(current_user, User.find(to_user_id), @reservation.message_thread_id, Settings.reservation.pair_guide_status.canceled).deliver_now!
      redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.reservation.pair_guide.success
    else
      redirect_to message_thread_path(pair_guide_params[:message_thread_id]), alert: Settings.reservation.pair_guide.failure
    end
  end
  
  def cancel_pair_guide_from_dashboard
    message_thread = PairGuideThread.existed_pair_guide_thread(@reservation, @reservation.pair_guide_id)
    if @reservation.update(pair_guide_params)
      message = Message.send_pair_guide_message(message_thread.id, Settings.reservation.msg.cancel_pair_guide_from_dashboard, current_user.id, @reservation.host_id)
      PairGuideMailer.send_update_pair_guide_notification(current_user, User.find(@reservation.host_id), message_thread.id, Settings.reservation.pair_guide_status.canceled).deliver_now!
      redirect_to message_thread_path(message_thread.id), notice: Settings.reservation.pair_guide.success
    else
      redirect_to message_thread_path(message_thread.id), alert: Settings.reservation.pair_guide.failure
    end
  end
  
  def accept_pair_guide
    if @reservation.update(pair_guide_params)
      message = Message.send_pair_guide_message(@reservation.message_thread_id, Settings.reservation.msg.pair_guide_accept, current_user.id, @reservation.host_id)
      @reservation.pg_completion!
      PairGuideMailer.send_update_pair_guide_notification(current_user, User.find(@reservation.host_id), @reservation.message_thread_id, Settings.reservation.pair_guide_status.accepted).deliver_now!
      redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.reservation.pair_guide.success
    else
      redirect_to message_thread_path(pair_guide_params[:message_thread_id]), alert: Settings.reservation.pair_guide.failure
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
      #@reservation.place = listing.listing_detail.place
      @reservation.place_memo = listing.listing_detail.place_memo
      #@reservation.space_option = listing.listing_detail.space_option
      @reservation.car_option = listing.listing_detail.car_option
      @reservation.bicycle_option = listing.listing_detail.bicycle_option
      @reservation.other_option = listing.listing_detail.other_option
      #@reservation.space_options.each do |option|
      #  @reservation[option] = listing.listing_detail[option]
      #end
      @reservation.car_options.each do |option|
        @reservation[option] = listing.listing_detail[option]
      end
      @reservation.bicycle_options.each do |option|
        @reservation[option] = listing.listing_detail[option]
      end
      @reservation.other_options.each do |option|
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
      @reservation = params[:reservation_id].present? ? Reservation.find(params[:reservation_id]) : Reservation.new
      @reservation.listing_id = listing.id
      user_id = listing.user_id
      if @reservation.try('id').nil?
        ngdates = Ngevent.get_ngdates_from_listing(listing)
        ngweeks = NgeventWeek.get_ngweeks_from_listing(listing).pluck(:dow)
      else
        ngdates = Ngevent.get_ngdates_except_request(@reservation, listing.id)
        ngweeks = NgeventWeek.get_ngweeks_from_listing(listing).pluck(:dow)
      end
      render json: { ngdates: ngdates, ngweeks: ngweeks}
    end
  end

  def set_ngday_reservation_default
    if request.xhr?
      @reservation = params[:reservation_id].present? ? Reservation.find(params[:reservation_id]) : Reservation.new
      user_id = @reservation.try('host_id')
      ngdates = Ngevent.get_ngdates_from_reservation(@reservation)
      ngweeks = NgeventWeek.get_ngweeks_from_reservation(@reservation).pluck(:dow)
      render json: { ngdates: ngdates, ngweeks: ngweeks}
    end
  end

  def exist_ngday_reservation
    if request.xhr?
      reservation = Reservation.find(params[:reservation_id])
      ret = Ngevent.is_settable_from_reservation(reservation)
      render json: { ret: ret }
    end
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id])
      @reservation.message_thread_id = reservation_params[:message_thread_id]
    end

    def check_profile_identity
      if params[:offer].present? or params[:confirm].present?
        unless current_user.already_authrized
          if current_user.profile_identity.present?
            return redirect_to edit_profile_profile_identity_path(current_user.profile, current_user.profile_identity), alert: params[:offer].present? ? Settings.reservation.save.failure.not_authorized_yet : Settings.reservation.accept.failure.not_authorized_yet
          else
            return redirect_to new_profile_profile_identity_path(current_user.profile), alert: params[:offer].present? ? Settings.reservation.save.failure.not_authorized_yet : Settings.reservation.accept.failure.not_authorized_yet
          end
        end
      end
    end

    def check_campaign_code
      if params[:confirm].present? and reservation_params[:campaign_code].present?
        @campaign = Campaign.where(code: reservation_params[:campaign_code]).first
        if @campaign.blank?
          redirect_to message_thread_path(reservation_params[:message_thread_id]), alert: Settings.reservation.save.failure.invalid_campaign_code
        elsif @campaign.users.exists?(current_user)
          redirect_to message_thread_path(reservation_params[:message_thread_id]), alert: Settings.reservation.save.failure.used_campaign_code
        else
          @reservation.campaign = @campaign
          session[:campaign_id] = @campaign.id
        end
      end
    end

    def checkout(reservation)
      respond_to do |format|
        setup_response = set_checkout(reservation)
        if reservation.valid? and setup_response.success?
          format.html { redirect_to gateway.redirect_url_for(setup_response.token)}
        else
          message_thread_id = session[:message_thread_id]
          session[:message_thread_id] = nil
          p setup_response
          format.html { redirect_to message_thread_path(message_thread_id), alert: setup_response.success? ? Settings.reservation.save.failure.no_date : Settings.reservation.save.failure.paypal_access_failure + ' error：' + setup_response.params['error_codes'] + ' ' + setup_response.params['message']}
        end
      end
    end

    def reservation_params
      params.require(:reservation).permit(:listing_id, :host_id, :guest_id, :num_of_people, :content, :progress, :reason,:time_required, :price, :price_for_support, :price_for_both_guides, :space_option, :car_option, :space_rental, :car_option, :car_rental, :gas, :highway, :parking, :bicycle_option, :bicycle_rental, :other_option, :other_cost, :guests_cost, :included_guests_cost, Reservation::REGISTRABLE_ATTRIBUTES, :place, :place_memo, :description, :message_thread_id, :schedule_end, :campaign_id, :campaign_code, :pair_guide_id, :pair_guide_status)
    end
  
    def pair_guide_params
      params.require(:reservation).permit(:pair_guide_id, :pair_guide_status, :message_thread_id)
    end
end
