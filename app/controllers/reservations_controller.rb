class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:show, :update, :destroy, :edit]
  
  def edit
  end
  
  def show
  end
  
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

  def update
    para = reservation_params
    if params[:cancel]
      para[:progress] = 1
      msg = Settings.reservation.msg.canceled
    elsif params[:accept]
      para[:progress] = 3
      msg = Settings.reservation.msg.accepted
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
          format.html { return redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.message.save.failure }
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
          format.html { redirect_to message_thread_path(@reservation.message_thread_id), notice: Settings.reservation.update.success }
          format.json { render :show, status: :ok, location: @reservation }
        else
          format.html { redirect_to message_thread_path(@reservation.message_thread_id) }
          format.json { render json: @reservation.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to message_thread_path(@reservation.message_thread_id) }
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
end
