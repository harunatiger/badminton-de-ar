class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :regulate_user!
  before_action :set_reservation
  before_action :set_review

  def new
    @review = Review.new
    @reservation.save_review_landed_at_now if @reservation.review_landed_at.blank?
  end

  def create
    @review = Review.new(review_params)
    respond_to do |format|
      if @review.save
        @reservation.save_reviewed_at_now
        #if ReviewMailer.send_review_reply_notification(@reservation, @review).deliver_later!(wait: 1.minute) # if you want to use active job, use this line.
        if ReviewMailer.send_review_reply_notification(@reservation, @review).deliver_now! # if you don't want to use active job, use this line.
          @reservation.save_reply_mail_sent_at_now
          format.html { redirect_to root_path, notice: Settings.review.save.success }
          format.json { render :show, status: :created, location: @review }
        end
      else
        flash.now[:alert] = Settings.review.save.failure
        format.html { render 'new'}
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_review
      @review = Review.find_by(reservation_id: params[:reservation_id])
    end

    def set_reservation
      @reservation = Reservation.find(params[:reservation_id])
    end

    def regulate_user!
      reservation = Reservation.where(id: params[:reservation_id].to_i).first
      if reservation.present?
        if current_user.id == reservation.guest_id
          if Review.exists?(reservation_id: reservation.id, guest_id: current_user.id)
            redirect_to root_path, alert: Settings.regulate_user.entry.duplicated
          else
            if Time.zone.now > reservation.review_expiration_date
              redirect_to root_path, alert: Settings.regulate_term.expired
            end
          end
        else
          redirect_to root_path, alert: Settings.regulate_user.user_id.failure
        end
      else
        redirect_to root_path, alert: Settings.regulate_user.reservation_id.failure
      end
    end

    def review_params
      params.require(:review).permit(:host_id, :guest_id, :listing_id, :reservation_id, :accuracy, :communication, :clearliness, :location, :check_in, :cost_performance, :total, :msg)
    end
end
