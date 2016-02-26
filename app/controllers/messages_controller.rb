class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :regulate_user!, only: [:download_attached_file]
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    @messages = Message.all
  end

  def show
  end

  def new
    @message = Message.new
  end

  def edit
  end

  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create
    if message_params[:message_thread_id]
      res = message_params[:message_thread_id]
    else
      res = MessageThread.exists_thread?(message_params)
    end
    if res
      mt_obj = MessageThread.find(res)
    else
      mt_obj = MessageThread.create_thread(message_params)
    end

    host_id = mt_obj.host_id.present? ? mt_obj.host_id.to_i : 0
    from_user_id = message_params[:from_user_id].present? ? message_params[:from_user_id].to_i : 0
    reply_from_host = host_id == from_user_id ? 1 : 0
    mail_to_admin = mt_obj.messages.present? ? 0 : 1

    if mt_obj.first_message?
      first_message = host_id == from_user_id ? 0 : 1
    else
      first_message = 0
    end

    respond_to do |format|
      ret = Message.send_message(mt_obj, message_params)
      if ret == true
        reservation_params = params['reservation']

        if reservation_params.present? && reservation_params['progress'].present?
          @reservation = Reservation.find(params['message']['reservation_id'])
          @reservation.progress = reservation_params['progress']
          unless @reservation.save
            format.html { return redirect_to dashboard_path, alert: Settings.message.save.failure }
            format.json { return render json: { success: false } } if request.xhr?
          end

          @ng_event = Ngevent.find_by(reservation_id: params['message']['reservation_id'])
          if reservation_params['progress'] == "accepted"
            @ng_event.update_attribute(:active, 1)
          else
            @ng_event.update_attribute(:active, 0)
          end
          unless @ng_event.save
            format.html { return redirect_to dashboard_path, alert: Settings.message.save.failure }
            format.json { return render json: { success: false } } if request.xhr?
          end

          if @reservation.accepted? || @reservation.rejected? || @reservation.under_construction? || @reservation.canceled? || @reservation.canceled_after_accepted?
            #ReservationMailer.send_update_reservation_notification(@reservation, current_user.id).deliver_later!(wait: 1.minute) # if you want to use active job, use this line.
            ReservationMailer.send_update_reservation_notification(@reservation, current_user.id).deliver_now! # if you don't want to use active job, use this line.
          else
            #MessageMailer.send_new_message_notification(mt_obj, message_params).deliver_later!(wait: 1.minute) # if you want to use active job, use this line.
            MessageMailer.send_new_message_notification(mt_obj, message_params).deliver_now! # if you don't want to use active job, use this line.
            if first_message == 1 && mail_to_admin == 1
              MessageMailer.send_new_message_notification_to_admin(mt_obj, message_params).deliver_now!
            end
          end
        else
          #MessageMailer.send_new_message_notification(mt_obj, message_params).deliver_later!(wait: 1.minute) # if you want to use active job, use this line.
          MessageMailer.send_new_message_notification(mt_obj, message_params).deliver_now! # if you don't want to use active job, use this line.
          if first_message == 1 && mail_to_admin == 1
            MessageMailer.send_new_message_notification_to_admin(mt_obj, message_params).deliver_now!
          end
        end

        mt_obj.update(reply_from_host: reply_from_host, first_message: first_message)

        format.html { return redirect_to message_thread_path(mt_obj.id), notice: Settings.message.save.success }
        format.json { return render json: { success: true } } if request.xhr?
      else
        error_message = ret == false ? Settings.message.save.failure : ret
        format.html { return redirect_to message_thread_path(mt_obj.id), alert: error_message }
        format.json { return render json: { success: false } } if request.xhr?
      end
    end
  end


  def show_preview
    if request.xhr?
      @message = Message.find(params[:id])
      render partial: 'message_threads/image_preview', locals: {m: @message}
    end
  end

  def download_attached_file
    if Rails.env.development?
      file = @message.attached_file.path
    else
      file = @message.attached_file.url
    end

    file_extension = @message.attached_extension.to_s
    file_name = @message.attached_name.to_s

    options = {}
    options[:type] = file_extension ? file_extension : 'text/plain'
    options[:filename] = file_name if file_name.present?

    data = open(file)
    ret = send_data data.read, options

  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    def regulate_user!
      @message = Message.find(params[:id])
      unless current_user.id == @message.to_user_id or current_user.id == @message.from_user_id
        redirect_to root_path, alert: Settings.regulate_user.user_id.failure
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:message_thread_id, :from_user_id, :to_user_id, :schedule, :num_of_people, :content, :attached_file, :progress, :read, :reservation_id, :listing_id)
    end
end
