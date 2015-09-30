class MessageThreadsController < ApplicationController
  before_action :authenticate_user!
  before_action :message_thread_user?, only: [:show, :create, :update, :destroy]
  before_action :set_message_thread, only: [:show, :update, :destroy]
  before_action :set_messages, only: [:show]
  before_action :set_reservation, only: [:show]

  # GET /message_threads
  # GET /message_threads.json
  def index
    message_thread_ids = MessageThreadUser.mine(current_user.id).pluck(:message_thread_id)
    @message_threads = []
    message_thread_ids.each do |mt_id|
      @message_threads << MessageThread.find(mt_id)
    end
    # @message_threads.sort_by! { |mt| mt.updated_at }
    @message_threads.sort_by! &:updated_at
    @message_threads.reverse!
  end

  # GET /message_threads/1
  # GET /message_threads/1.json
  def show
    Message.make_all_read(@message_thread.id, current_user.id)
    counterpart_user_id = MessageThreadUser.counterpart_user(@message_thread.id, current_user.id)
    @message = Message.new
    @messages
    @counterpart = User.find(counterpart_user_id)
  end

  # POST /message_threads
  # POST /message_threads.json
  def create
    @message_thread = MessageThread.new(message_thread_params)

    respond_to do |format|
      if @message_thread.save
        format.html { redirect_to @message_thread, notice: 'Message thread was successfully created.' }
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
      message = @messages.where.not(listing_id: 0).first
      @guest_id = message.guest_id
      @host_id = message.host_id
      reservation = Reservation.active_reservation(@guest_id, @host_id)
      @reservation = reservation.present? ? Reservation.new(reservation.attributes) : Reservation.new(listing_id: message.listing_id)
      @reservation.message_thread_id = @message_thread.id
    end

    def message_thread_user?
      redirect_to message_threads_path unless MessageThreadUser.is_a_member(params[:id], current_user.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_thread_params
      params.require(:message_thread).permit(:id)
    end
end
