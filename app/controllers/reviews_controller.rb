class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :regulate_user_for_guide!, only: [:for_guide, :create_guide]
  before_action :regulate_user_for_guest!, only: [:for_guest, :create_guest]
  before_action :set_reservation
  #before_action :set_review

  def for_guest
    @review = ReviewForGuest.new
  end
  
  def for_guide
    @review = ReviewForGuide.new
  end
  
  def create_guest
    @review = Review.new(review_params)
    respond_to do |format|
      if @review.save
        @reservation.save_replied_at_now
        if @reservation.reviewed_at.present?
          @reservation.save_review_opened_at_now
          @review.calc_average
          notice = Settings.review.opened
          ReviewMailer.send_review_accept_notification(@review.host_id, @review.guest_id).deliver_now!
          ReviewMailer.send_review_accept_notification(@review.guest_id, @review.host_id).deliver_now!
        else
          notice = Settings.review.for_guest.save.success
        end
        format.html { redirect_to root_path, notice: notice }
      else
        flash.now[:alert] = Settings.review.for_guest.save.failure
        format.html { render 'for_guest'}
      end
    end
  end
  
  def create_guide
    @review = Review.new(review_params)
    respond_to do |format|
      if @review.save
        @reservation.save_reviewed_at_now
        if @reservation.replied_at.present?
          @reservation.save_review_opened_at_now 
          @review.calc_average
          notice = Settings.review.opened
          ReviewMailer.send_review_accept_notification(@review.host_id, @review.guest_id).deliver_now!
          ReviewMailer.send_review_accept_notification(@review.guest_id, @review.host_id).deliver_now!
        else
          notice = Settings.review.for_guide.save.success
        end
        
        format.html { redirect_to root_path, notice: notice }
      else
        flash.now[:alert] = Settings.review.for_guide.save.failure
        format.html { render 'for_guide'}
      end
    end
  end

  private
    #def set_review
    #  @review = Review.find_by(reservation_id: params[:reservation_id])
    #end

    def set_reservation
      @reservation = Reservation.find(params[:reservation_id])
    end

    def regulate_user_for_guide!
      reservation = Reservation.where(id: params[:reservation_id].to_i).first
      if reservation.present?
        if current_user.id == reservation.guest_id
          if User.find(reservation.host_id).soft_destroyed?
            redirect_to session[:previous_url].present? ? session[:previous_url] : root_path, alert: Settings.profile.deleted_profile_id
          elsif ReviewForGuide.exists?(reservation_id: reservation.id)
            redirect_to root_path, alert: Settings.regulate_user.entry.duplicated
          elsif !reservation.review_for_guide_enabled?
            redirect_to root_path, alert: Settings.regulate_term.expired
          end
        else
          redirect_to root_path, alert: Settings.regulate_user.user_id.failure
        end
      else
        redirect_to root_path, alert: Settings.regulate_user.reservation_id.failure
      end
    end
  
    def regulate_user_for_guest!
      reservation = Reservation.where(id: params[:reservation_id].to_i).first
      if reservation.present?
        if current_user.id == reservation.host_id
          if User.find(reservation.guest_id).soft_destroyed?
            redirect_to session[:previous_url].present? ? session[:previous_url] : root_path, alert: Settings.profile.deleted_profile_id
          elsif ReviewForGuest.exists?(reservation_id: reservation.id)
            redirect_to root_path, alert: Settings.regulate_user.entry.duplicated
          end
        else
          redirect_to root_path, alert: Settings.regulate_user.user_id.failure
        end
      else
        redirect_to root_path, alert: Settings.regulate_user.reservation_id.failure
      end
    end

    def review_params
      params.require(params[:review_for_guide].present? ? :review_for_guide : :review_for_guest).permit(:host_id, :guest_id, :listing_id, :reservation_id, :accuracy, :communication, :clearliness, :location, :check_in, :cost_performance, :total, :msg, :type)
    end
end
