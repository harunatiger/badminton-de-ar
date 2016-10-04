class MessageThreadsController < ApplicationController
  before_action :store_location, only: [:index, :show]
  before_action :authenticate_user!
  before_action :message_thread_user?, only: [:show, :update, :destroy, :what_talk_about, :start_planning]
  before_action :set_message_thread, only: [:show, :update, :destroy, :what_talk_about, :start_planning]
  before_action :set_messages, only: [:show]
  before_action :set_reservation, only: [:show]
  before_action :set_create_user, only: [:show]
  before_action :set_language, only: [:show]

  # GET /message_threads
  # GET /message_threads.json
  def index
    message_threads_ids = MessageThreadUser.mine(current_user.id).pluck(:message_thread_id)
    @message_threads = []
    message_threads_ids.each do |mt_id|
      message_thread = MessageThread.find(mt_id)
      if message_thread.messages.present? || message_thread.create_user_id == current_user.id
        @message_threads << message_thread.set_reservation_progress
      end
    end
    @message_threads.sort_by! &:updated_at
    @message_threads.reverse!
  end

  # GET /message_threads/1
  # GET /message_threads/1.json
  def show
    @what_talk_about = session[:what_talk_about]
    session[:what_talk_about] = nil
    Message.make_all_read(@message_thread.id, current_user.id)
    @message = Message.new
    @counterpart = @message_thread.counterpart_user(current_user.id)
    flash.now[:alert] = Settings.profile.deleted_profile_id if @counterpart.soft_destroyed?
    if @message_thread.guest_thread?
      @listings = User.find(@host_id).listings.opened.without_soft_destroyed
      if @reservation.try('id').nil?
        gon.watch.ngdates = Ngevent.fix_common_ngdays(current_user.id)
        gon.watch.ngweeks = NgeventWeek.fix_common_ngweeks(current_user.id).pluck(:dow)
      else
        gon.watch.ngdates = Ngevent.get_ngdates_except_request(@reservation, @reservation.try('listing_id'))
        gon.watch.ngweeks = NgeventWeek.get_ngweeks_from_reservation(@reservation).pluck(:dow)
      end
      @reservations = Reservation.where(host_id: @host_id, guest_id: @message_thread.counterpart_user(@host_id).id)
    elsif @message_thread.pair_guide_thread?
      @listing = Listing.find(@reservation.listing_id)
    end
  end
  
  def talk_to_me
    session[:what_talk_about] = true if params[:what_talk_about]
    redirect_to message_thread_path(params[:id])
  end
  
  def what_talk_about
    mail_to_admin = @message_thread.messages.present? ? false : true
    if message_params = Message.send_what_talk_about(@message_thread, current_user.id, params[:content])
      MessageMailer.send_new_message_notification(@message_thread, message_params).deliver_now!
      MessageMailer.send_new_message_notification_to_admin(@message_thread, message_params).deliver_now! if mail_to_admin
      redirect_to message_thread_path(@message_thread.id), notice: Settings.message.save.success
    else
      redirect_to message_thread_path(@message_thread.id), alert: Settings.message.save.failure
    end
  end

  # POST /message_threads
  # POST /message_threads.json
  # only for GuestThread and DefaultThread
  def create
    session[:what_talk_about] = true if params[:what_talk_about]
    @message_thread = MessageThread.new(message_thread_params)
    @message_thread.message_thread_users.build(user_id: current_user.id)
    @message_thread.message_thread_users.build(user_id: @message_thread.host_id)
    @message_thread.host_id = nil unless @message_thread.guest_thread?
    respond_to do |format|
      if @message_thread.save
        format.html { redirect_to message_thread_path(@message_thread.id)}
        format.json { render :show, status: :created, location: @message_thread }
      else
        format.html { render :new }
        format.json { render json: @message_thread.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /message_threads/1
  # PATCH/PUT /message_threads/1.json
  def update
    respond_to do |format|
      if @message_thread.update(message_thread_params)
        format.html { redirect_to @message_thread, notice: 'Message thread was successfully updated.' }
        format.json { render :show, status: :ok, location: @message_thread }
      else
        format.html { render :edit }
        format.json { render json: @message_thread.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def start_planning
    guest_thread_id = @message_thread.get_guest_thread_id(current_user.id)
    redirect_to message_thread_path(guest_thread_id), notice: Settings.message_thread.start_planning
  end

  # DELETE /message_threads/1
  # DELETE /message_threads/1.json
  def destroy
    @message_thread.destroy
    respond_to do |format|
      format.html { redirect_to message_threads_url, notice: 'Message thread was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def change_language
    if request.xhr?
      session[:edit_language] = params[:language]
      return render text: 'success'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message_thread
      @message_thread = MessageThread.find(params[:id])
    end

    def set_messages
      @messages = Message.message_thread(params[:id]).order_by_created_at_desc
    end

    def set_reservation
      @guest_id = @message_thread.counterpart_user(@message_thread.host_id).id
      @host_id = @message_thread.pair_guide_thread? ? @message_thread.reservation.host_id : @message_thread.host_id
      @reservation = @message_thread.pair_guide_thread? ? @message_thread.reservation : Reservation.for_message_thread(@guest_id, @host_id)
      @reservation.message_thread_id = @message_thread.id
    end

    def message_thread_user?
      redirect_to message_threads_path unless MessageThreadUser.is_a_member(params[:id], current_user.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_thread_params
      params.require(:message_thread).permit(:id, :host_id, :type)
    end
  
    def set_create_user
      if @message_thread.create_user_id.blank? && @message_thread.messages.blank?
        @message_thread.update(create_user_id: current_user.id)
      end
    end
  
    def set_language
      session[:edit_language] = Settings.laguages.ja if session[:edit_language].blank?
    end
end
