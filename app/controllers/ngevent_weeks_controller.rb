class NgeventWeeksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_week, only: [:destroy]

  def index
    @ngevent_weeks = NgeventWeek.where(user_id: current_user.id)
  end

  def common_ngweeks
    @ngevent_weeks = NgeventWeek.where(user_id: current_user.id, mode: 1)
  end

  def except_common_ngweeks
    @ngevent_weeks = NgeventWeek.where(user_id: current_user.id, mode: 0)
  end

  def listing_ngweeks
    @ngevent_weeks = NgeventWeek.where(listing_id: params[:listing_id], mode: 0)
  end

  def show
  end

  def create
    ngevent_week_params = Hash[
      'listing_id' => params[:listing_id],
      'mode' => params['event']['mode'],
      'user_id' => current_user.id,
      'dow' => params['event']['dow']
    ]

    @ngevent_week = NgeventWeek.new(ngevent_week_params)

    current_week = NgeventWeek.where(listing_id: params[:listing_id], dow: params['event']['dow'])

    unless current_week.blank?
      return render json: { msg: 'ng_week configured', event: @ngevent_week }, status: 4001
    end


    respond_to do |format|
      if @ngevent_week.save!
        format.html { redirect_to @ngevent_week, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @ngevent_week }
      else
        format.html { render :new }
        format.json { render json: @ngevent_week.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
  end

  def destroy
    @ngevent_week.destroy
    respond_to do |format|
      format.html { redirect_to ngevents_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def unset
    listing_id = params[:listing_id].present? ? params[:listing_id] : 0
    user_id = current_user.id
    dow = params['event']['dow']
    mode = params['event']['mode']

    @ngevent_week = NgeventWeek.find_by(listing_id: listing_id,user_id: user_id, dow: dow, mode: mode)

    if @ngevent_week.nil?
      return render json: { msg: 'ng_week already unset', event: @ngevent_week }, status: 4001
    end

    @ngevent_week.destroy
    respond_to do |format|
      format.html { redirect_to ngevents_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_week
      @ngevent_week = NgeventWeek.find(params[:id])
    end
end
