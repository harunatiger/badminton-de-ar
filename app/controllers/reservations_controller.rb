class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:show, :update, :destroy]
  include Payments
  
  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.progress = 'requested'
    reservation = Reservation.requested_reservation(@reservation.guest_id, @reservation.host_id)
    reservation.update(progress: 'rejected') if reservation.present?
    respond_to do |format|
      if @reservation.save
        ngevent_params = Hash[
          'reservation_id' => @reservation.id,
          'listing_id' => @reservation.listing_id,
          'user_id' => @reservation.host_id,
          'start' => @reservation.schedule,
          'end' => @reservation.schedule,
          'end_bk' => @reservation.schedule,
          'mode' => 1,  # 1:reservation_mode
          'active' => 0,# 0:no actice
          'color' => 'red'
        ]
        Ngevent.create(ngevent_params)
        ReservationMailer.send_new_reservation_notification(@reservation).deliver_now!
        msg_params = Hash[
          'reservation_id' => @reservation.id,
          'listing_id' => @reservation.listing_id,
          'from_user_id' => @reservation.host_id,
          'to_user_id' => @reservation.guest_id,
          'progress' => @reservation.progress,
          'schedule' => @reservation.schedule,
          'content' => Settings.reservation.msg.request
        ]

        if res = MessageThread.exists_thread?(msg_params)
          mt_obj = MessageThread.find(res)
        else
          mt_obj = MessageThread.create_thread(msg_params)
        end

        if Message.send_message(mt_obj, msg_params)
          format.html { redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.reservation.save.success }
          format.json { render :show, status: :created, location: @reservation }
        else
          format.html { redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.reservation.save.failure.no_date }
          format.json { render json: @reservation.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.reservation.save.failure.no_date }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def confirm
    @reservation = Reservation.find(session[:reservation_id])
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
        format.html { redirect_to message_thread_path(session[:message_thread_id]), notice: Settings.reservation.save.failure.paypal_access_failure + ' エラー：' + details.params['error_codes'] + ' ' + details.params['message']}
      end
    end
    @listing = Listing.find(@reservation.listing_id)
  end
  
  def cancel
    message_thread_id = session[:message_thread_id]
    session[:reservation_id] = nil
    session[:message_thread_id] = nil
    respond_to do |format|
      format.html { redirect_to message_thread_path(message_thread_id), notice: Settings.reservation.save.failure.paypal_canceled}
    end
  end

  def update
    para = reservation_params
    message_thread_id = para[:message_thread_id].present? ? para[:message_thread_id] : session[:message_thread_id]
    session[:message_thread_id] = nil
    payment = @reservation.payment
    if params[:cancel]
      if payment.present? and payment.payment_status == 'Completed' and payment.cancel_available
        response = refund(payment)
        unless response.success?
          respond_to do |format|
            format.html { return redirect_to message_thread_path(message_thread_id), notice: Settings.reservation.save.failure.paypal_refund_failure + ' エラー：' + response.params['error_codes'] + ' ' + response.params['message']}
            format.json { return render :show, status: :ok, location: @reservation }
          end 
        else
          payment.transaction_id = response.params['refund_transaction_id']
          payment.refund_date = response.params['timestamp']
          payment.payment_status = 'Refunded'
          payment.save
        end
      end
      para[:progress] = 1
    elsif params[:accept]
      session[:message_thread_id] = message_thread_id
      session[:reservation_id] = @reservation.id
      return checkout(@reservation) if @reservation.price > 0
      para[:progress] = 3
      msg = Settings.reservation.msg.accepted
    elsif params[:payment]
      response = purchase(payment)
      if response.success?
        payment.transaction_id = response.params['transaction_id']
        payment.transaction_date = response.params['payment_date']
        payment.payment_status = response.params['payment_status']
        payment.save
      else
        respond_to do |format|
          format.html { return redirect_to message_thread_path(message_thread_id), notice: Settings.reservation.save.failure.paypal_payment_failure + ' エラー：' + response.params['error_codes'] + ' ' + response.params['message']}
          format.json { return render :show, status: :ok, location: @reservation }
        end 
      end
      para[:progress] = 3
      msg = Settings.reservation.msg.accepted
    elsif params[:payment_cancel]
      respond_to do |format|
        format.html { return redirect_to message_thread_path(message_thread_id), notice: Settings.reservation.save.failure.paypal_canceled }
        format.json { return render :show, status: :ok, location: @reservation }
      end 
    end

    respond_to do |format|
      if @reservation.update(para)
        
        @ng_event = Ngevent.find_by(reservation_id: @reservation.id)
        if @reservation.progress == "accepted"
          @ng_event.update_attribute(:active, 1)
        else
          @ng_event.update_attribute(:active, 0)
        end
        unless @ng_event.save
          format.html { return redirect_to message_thread_path(message_thread_id), notice: Settings.message.save.failure }
          format.json { return render json: { success: false } } if request.xhr?
        end
        
        ReservationMailer.send_update_reservation_notification(@reservation, @reservation.guest_id).deliver_now!
        msg_params = Hash[
          'reservation_id' => @reservation.id,
          'listing_id' => @reservation.listing_id,
          'from_user_id' => @reservation.guest_id,
          'to_user_id' => @reservation.host_id,
          'progress' => @reservation.progress,
          'schedule' => @reservation.schedule,
          'content' => msg
        ]

        if res = MessageThread.exists_thread?(msg_params)
          mt_obj = MessageThread.find(res)
        else
          mt_obj = MessageThread.create_thread(msg_params)
        end

        if Message.send_message(mt_obj, msg_params)
          format.html { redirect_to message_thread_path(message_thread_id), notice: Settings.reservation.update.success }
          format.json { render :show, status: :ok, location: @reservation }
        else
          format.html { redirect_to message_thread_path(message_thread_id) }
          format.json { render json: @reservation.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to message_thread_path(message_thread_id), notice: Settings.reservation.update.failure }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:listing_id, :host_id, :guest_id, :num_of_people, :content, :progress, :reason,:time_required, :price, :option_price, Reservation::REGISTRABLE_ATTRIBUTES, :place, :description, :message_thread_id)
    end
  
    def checkout(reservation)
      respond_to do |format|
        setup_response = set_checkout(reservation)
        if reservation.valid? and setup_response.success?        
          session[:reservation] = reservation
          format.html {redirect_to gateway.redirect_url_for(setup_response.token)}
        else
          message_thread_id = session[:message_thread_id]
          session[:message_thread_id] = nil
          p setup_response
          format.html { redirect_to message_thread_path(message_thread_id), notice: setup_response.success? ? Settings.reservation.save.failure.no_date : Settings.reservation.save.failure.paypal_access_failure + ' エラー：' + setup_response.params['error_codes'] + ' ' + setup_response.params['message']}
          format.json { render json: reservation.errors, status: :unprocessable_entity }
        end
      end
    end
end
