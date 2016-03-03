class ReviewRepliesController < ApplicationController
  before_action :authenticate_user!
  before_action :regulate_user!
  before_action :set_reservation
  before_action :set_review
  #before_action :set_review_reply
  
  def new
    @review_reply = ReviewReply.new
    @reservation.save_reply_landed_at_now if @reservation.reply_landed_at.blank?
  end

  def create
    @review_reply = ReviewReply.new(review_reply_params)
    respond_to do |format|
      if @review_reply.save
        @reservation.save_replied_at_now
        @reservation.save_review_opened_at_now
        @review.calc_average
        ReviewMailer.send_review_accept_notification(@review).deliver_now!
        format.html { redirect_to root_path, notice: Settings.review_reply.save.success }
        format.json { render :show, status: :created, location: @review_reply }
      else
        flash.now[:alert] = Settings.review_reply.save.failure
        format.html { render 'new'}
        format.json { render json: @review_reply.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #def set_review_reply
    #  @review_reply = ReviewReply.find_by(review_id: @review.id)
    #end

    def set_review
      @review = Review.find_by(reservation_id: params[:reservation_id])
    end

    def set_reservation
      @reservation = Reservation.find(params[:reservation_id])
    end

    def regulate_user!
      reservation = Reservation.where(id: params[:reservation_id].to_i).first
      review = Review.where(reservation_id: params[:reservation_id].to_i).first
      if reservation.present?
        if current_user.id == reservation.host_id
          if review.present? and ReviewReply.exists?(review_id: review.id)
            redirect_to root_path, alert: Settings.regulate_user.entry.deplicated
          end
        else
          redirect_to root_path, alert: Settings.regulate_user.user_id.failure
        end
      else
        direct_to root_path, alert: Settings.regulate_user.reservation_id.failure
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_reply_params
      params.require(:review_reply).permit(:review_id, :accuracy, :communication, :clearliness, :location, :check_in, :cost_performance, :total, :msg)
    end
end
