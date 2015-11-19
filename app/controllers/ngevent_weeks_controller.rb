class NgeventWeeksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event_week, only: [:destroy]

  def index
    @ngevent_weeks = NgeventWeek.where(listing_id: params[:listing_id])
  end

  def show
  end

  def create
    ngevent_week_params = Hash[
      'listing_id' => params[:listing_id],
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
    ngevent_week_params = Hash[
      'listing_id' => params[:listing_id],
      'dow' => params['event']['dow']
    ]

    @ngevent_week = NgeventWeek.find_by(listing_id: params[:listing_id], dow: params['event']['dow'])

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
