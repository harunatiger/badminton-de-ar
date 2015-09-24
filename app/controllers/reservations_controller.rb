class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:show, :update, :destroy, :edit]
  
  def edit
  end
  
  def show
  end
  
  def create
    @reservation = Reservation.new(reservation_params)
    profile_id = User.user_id_to_profile_id(@reservation.guest_id)
    #return redirect_to edit_profile_path(profile_id), notice: Settings.reservation.requirement.profile.not_yet unless Profile.minimun_requirement?(@reservation.guest_id)
    #return redirect_to new_profile_profile_image_path(profile_id), notice: Settings.reservation.requirement.profile_image.not_yet unless ProfileImage.minimun_requirement?(@reservation.guest_id, profile_id)
    respond_to do |format|
      if @reservation.save
        # ReservationMailer.send_new_reservation_notification(@reservation).deliver_later!(wait: 1.minute) # if you want to use active job, use this line.
        ReservationMailer.send_new_reservation_notification(@reservation).deliver_now! # if you don't want to use active job, use this line. 

        msg_params = Hash[
          'reservation_id' => @reservation.id,
          'listing_id' => @reservation.listing_id,
          'from_user_id' => @reservation.guest_id,
          'to_user_id' => @reservation.host_id,
          'progress' => @reservation.progress,
          'schedule' => @reservation.schedule,
          'num_of_people' => @reservation.num_of_people,
          'content' => Settings.reservation.msg.request
        ]

        if res = MessageThread.exists_thread?(msg_params)
          mt_obj = MessageThread.find(res)
        else
          mt_obj = MessageThread.create_thread(msg_params)
        end

        if Message.send_message(mt_obj, msg_params)
          format.html { redirect_to dashboard_guest_reservation_manager_path, notice: Settings.reservation.save.success }
          format.json { render :show, status: :created, location: @reservation }
        else
          format.html { redirect_to listing_path(@reservation.listing_id), notice: Settings.reservation.save.failure.no_date }
          format.json { render json: @reservation.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to listing_path(@reservation.listing_id), notice: Settings.reservation.save.failure.no_date }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to dashboard_guest_reservation_manager_path(@listing, @reservation), notice: Settings.reservation.update.success }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    def reservation_params
      params.require(:reservation).permit(:listing_id, :host_id, :guest_id, :schedule, :num_of_people, :content, :progress, :reason,:time_required, :price, :option_price, :schedule_hour, :schedule_minute, :place, :description)
    end
end
