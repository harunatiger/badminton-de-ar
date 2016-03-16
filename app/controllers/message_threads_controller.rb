class MessageThreadsController < ApplicationController
  before_action :authenticate_user!
  before_action :message_thread_user?, only: [:show, :update, :destroy]
  before_action :set_message_thread, only: [:show, :update, :destroy]
  before_action :set_messages, only: [:show]
  before_action :set_reservation, only: [:show]

  # GET /message_threads
  # GET /message_threads.json
  def index
    message_threads_ids = MessageThreadUser.mine(current_user.id).pluck(:message_thread_id)
    @message_threads = []
    message_threads_ids.each do |mt_id|
      message_thread = MessageThread.find(mt_id)
      @message_threads << message_thread.set_reservation_progress if message_thread.messages.present?
    end
    @message_threads.sort_by! &:updated_at
    @message_threads.reverse!
  end

  # GET /message_threads/1
  # GET /message_threads/1.json
  def show
    Message.make_all_read(@message_thread.id, current_user.id)
    @message = Message.new
    @counterpart = @message_thread.counterpart_user(current_user.id)
    flash.now[:alert] = Settings.profile.deleted_profile_id if @counterpart.soft_destroyed?
    if @message_thread.guest_thread?
      @listings = User.find(@host_id).listings.opened.without_soft_destroyed
      gon.watch.ngdates = Ngevent.get_ngdates_except_request(@host_id, @reservation.id)
      gon.watch.ngweeks = NgeventWeek.where(user_id: @host_id).pluck(:dow)
    end
  end

  # POST /message_threads
  # POST /message_threads.json
  def create
    @message_thread = MessageThread.new(message_thread_params)
    @message_thread.message_thread_users.build(user_id: current_user.id)
    @message_thread.message_thread_users.build(user_id: @message_thread.host_id)
    respond_to do |format|
      if @message_thread.save
        format.html { redirect_to @message_thread}
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

  # DELETE /message_threads/1
  # DELETE /message_threads/1.json
  def destroy
    @message_thread.destroy
    respond_to do |format|
      format.html { redirect_to message_threads_url, notice: 'Message thread was successfully destroyed.' }
      format.json { head :no_content }
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
      @host_id = @message_thread.host_id
      @reservation = Reservation.for_message_thread(@guest_id, @host_id)
      @reservation.message_thread_id = @message_thread.id
    end

    def message_thread_user?
      redirect_to message_threads_path unless MessageThreadUser.is_a_member(params[:id], current_user.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_thread_params
      params.require(:message_thread).permit(:id, :host_id)
    end
end
