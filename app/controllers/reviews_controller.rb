class ReviewsController < ApplicationController
  before_action :store_location, only: [:for_guest, :for_guide]
  before_action :authenticate_user!, except: [:unscheduled_tour]
  before_action :regulate_user_for_guide!, only: [:for_guide, :create_guide]
  before_action :regulate_user_for_guest!, only: [:for_guest, :create_guest]
  before_action :set_reservation, except: [:unscheduled_tour, :create_unscheduled_tour]
  before_action :set_unscheduled_tour, only: [:unscheduled_tour, :create_unscheduled_tour]
  before_action :regulate_user_for_unscheduled_tour!, only: [:create_unscheduled_tour]
  #before_action :set_review

  def for_guest
    @review = ReviewForGuest.new
  end

  def for_guide
    @review = ReviewForGuide.new
  end
  
  def unscheduled_tour
    @review = ReviewOfUnscheduledTour.new
  end

  def create_guest
    @review = Review.new(review_params)
    respond_to do |format|
      if @review.save
        if @review.anothre_review_exist?
          @reservation.save_replied_at_now
          if @reservation.reviewed_at.present?
            @reservation.save_review_opened_at_now
            @review.host_review.re_calc_average
            @reservation.create_pair_guide_review
            notice = Settings.review.opened
            ReviewMailer.send_review_accept_notification(@reservation.host_id, @reservation.guest_id).deliver_now!
            ReviewMailer.send_review_accept_notification(@reservation.pair_guide_id, @reservation.guest_id).deliver_now!
            ReviewMailer.send_review_accept_notification(@reservation.guest_id, @reservation.host_id).deliver_now!
          else
            notice = Settings.review.for_guest.save.success
          end
        else
          notice = Settings.review.for_guest.save.success
        end
        format.html { redirect_to root_path, notice: notice }
      else
        #flash.now[:alert] = Settings.review.for_guest.save.failure
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
          @review.re_calc_average
          @reservation.create_pair_guide_review
          notice = Settings.review.opened
          ReviewMailer.send_review_accept_notification(@reservation.host_id, @reservation.guest_id).deliver_now!
          ReviewMailer.send_review_accept_notification(@reservation.pair_guide_id, @reservation.guest_id).deliver_now!
          ReviewMailer.send_review_accept_notification(@reservation.guest_id, @reservation.host_id).deliver_now!
        else
          notice = Settings.review.for_guide.save.success
        end

        format.html { redirect_to root_path, notice: notice }
      else
        #flash.now[:alert] = Settings.review.for_guide.save.failure
        format.html { render 'for_guide'}
      end
    end
  end
  
  def create_unscheduled_tour
    @review = Review.new(review_params)
    if @review.valid?
      @review.save
      @review.re_calc_average
      @unscheduled_tour.users.each do |suport_guide|
        suport_guide_review = Review.new(review_params)
        suport_guide_review.host_id = suport_guide.id
        suport_guide_review.save
        suport_guide_review.re_calc_average
      end
      redirect_to root_path, notice: Settings.review.opened
    else
      render 'unscheduled_tour'
    end
  end

  private

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
        if current_user.id == reservation.host_id or current_user.id == reservation.pair_guide_id
          if User.find(reservation.guest_id).soft_destroyed?
            redirect_to session[:previous_url].present? ? session[:previous_url] : root_path, alert: Settings.profile.deleted_profile_id
          elsif ReviewForGuest.exists?(reservation_id: reservation.id, host_id: current_user.id)
            redirect_to root_path, alert: Settings.regulate_user.entry.duplicated
          end
        else
          redirect_to root_path, alert: Settings.regulate_user.user_id.failure
        end
      else
        redirect_to root_path, alert: Settings.regulate_user.reservation_id.failure
      end
    end
  
    def set_unscheduled_tour
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure unless @unscheduled_tour = UnscheduledTour.find_by_uuid(params[:unscheduled_tour_uuid])
    end
  
    def regulate_user_for_unscheduled_tour!
      return redirect_to root_path, alert: Settings.regulate_user.user_id.failure if @unscheduled_tour.guide_id == current_user.id || @unscheduled_tour.users.exists?(current_user) || ReviewOfUnscheduledTour.exists?(unscheduled_tour_id: @unscheduled_tour.id, guest_id: current_user.id)
    end

    def review_params
      review_type = params[:review_for_guest].present? ? :review_for_guest : params[:review_for_guide].present? ? :review_for_guide : :review_of_unscheduled_tour
      params.require(review_type).permit(:host_id, :guest_id, :listing_id, :reservation_id, :unscheduled_tour_id, :accuracy, :communication, :clearliness, :location, :check_in, :cost_performance, :total, :msg, :type, :tour_image)
    end
end
