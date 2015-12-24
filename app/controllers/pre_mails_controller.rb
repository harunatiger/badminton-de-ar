class PreMailsController < ApplicationController
  before_action :set_pre_mail, only: [:show, :edit, :update, :destroy]

  # GET /pre_mails
  # GET /pre_mails.json
  def index
    @pre_mails = PreMail.all
  end

  # GET /pre_mails/1
  # GET /pre_mails/1.json
  def show
  end

  # GET /pre_mails/new
  def new
    @pre_mail = PreMail.new
  end

  # GET /pre_mails/1/edit
  def edit
  end

  # POST /pre_mails
  # POST /pre_mails.json
  def create
    @pre_mail = PreMail.new(pre_mail_params)
    respond_to do |format|
      if user_signed_in? and current_user.pre_mail.blank?
        @pre_mail.email = current_user.email
        if @pre_mail.save
          PreMailer.send_pre_mail(@pre_mail, current_user).deliver_now!
          PreMailer.send_pre_mail_to_user(@pre_mail).deliver_now!
          format.html { redirect_to listings_path, notice: Settings.pre_mail.save.success }
        else
          format.html { redirect_to listings_path, notice: Settings.pre_mail.save.failure }
        end
      elsif !user_signed_in?
        if @pre_mail.save
          PreMailer.send_pre_mail(@pre_mail).deliver_now!
          PreMailer.send_pre_mail_to_user(@pre_mail).deliver_now!
          format.html { redirect_to root_path, notice: Settings.pre_mail.save.success }
        else
          format.html { redirect_to root_path, notice: Settings.pre_mail.save.failure }
        end
      else
        format.html { redirect_to root_path, notice: Settings.pre_mail.save.failure }
      end
    end
  end

  # PATCH/PUT /pre_mails/1
  # PATCH/PUT /pre_mails/1.json
  def update
    respond_to do |format|
      if @pre_mail.update(pre_mail_params)
        format.html { redirect_to @pre_mail, notice: 'Pre mail was successfully updated.' }
        format.json { render :show, status: :ok, location: @pre_mail }
      else
        format.html { render :edit }
        format.json { render json: @pre_mail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pre_mails/1
  # DELETE /pre_mails/1.json
  def destroy
    @pre_mail.destroy
    respond_to do |format|
      format.html { redirect_to pre_mails_url, notice: 'Pre mail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pre_mail
      @pre_mail = PreMail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pre_mail_params
      params.require(:pre_mail).permit(:user_id, :email)
    end
end
