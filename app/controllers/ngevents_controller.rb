class NgeventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /listings/ + listing_id + /ngevents
  # GET /listings/ + listing_id + /ngevents.json
  def index
    @ngevents = Ngevent.fix_ngdates_for_show(current_user.id)
  end

  def reservation_ngdays
    @ngevents = Ngevent.fix_reservation_ngdays_for_show(current_user.id)
  end

  def request_ngdays
    @ngevents = Ngevent.fix_request_ngdays_for_show(current_user.id)
  end

  def common_ngdays
    @ngevents = Ngevent.fix_common_ngdays_for_show(current_user.id)
  end

  def select_ngdays
    if request.xhr?
      arry_ngday = params[:arry_ngday]
      arry_ngweek = params[:arry_ngweek]

      if arry_ngday.present?
        ngevents = Ngevent.select_ngdays(current_user.id, arry_ngday)
      end

      if arry_ngweek.present?
        ngweeks = NgeventWeek.select_ngweeks(current_user.id, arry_ngweek)
      end

      result_array = [ngevents, ngweeks].compact.reduce([], :|)
      render json: { ngevents: result_array }
    end
  end

  # GET /ngevents/1
  # GET /ngevents/1.json
  def show
  end

  # POST /listings/ + listing_id + /ngevents
  # POST /listings/ + listing_id + /ngevents.json
  def create
    listing_id = params[:listing_id].present? ? params[:listing_id] : 0
    ngevent_params = Hash[
      'user_id' => current_user.id,
      'listing_id' => listing_id,
      'start' => params['event']['start'],
      'end' => params['event']['end'].to_date.yesterday,
      'end_bk' => params['event']['end'].to_date.yesterday,
      'mode' => params['event']['mode']
    ]
    @ngevent = Ngevent.new(ngevent_params)
    unless @ngevent.is_settable(params[:id], params[:listing_id])
      if request.xhr?
        return render json: { status: 'exist' }
      else
        return render json: { msg: 'ng date', event: @ngevent }, status: 4001
      end
    end
    respond_to do |format|
      if @ngevent.save!
        if request.xhr?
          format.json { return render json: { status: 'success', ngevent: @ngevent  } }
        else
          format.html { redirect_to @ngevent, notice: 'Event was successfully created.' }
          format.json { render :show, status: :created, location: @ngevent }
        end
      else
        if request.xhr?
          format.json { return render json: { status: 'error' } }
        else
          format.html { render :new }
          format.json { render json: @ngevent.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /ngevents/1
  # PATCH/PUT /ngevents/1.json
  def update
    if @ngevent.mode == 1
      return render json: { msg: 'ng date', event: @ngevent }, status: 4001
    end
    ngevent_params = Hash[
      'user_id' => current_user.id,
      'start' => params['event']['start'],
      'end' => params['event']['end'].to_date.yesterday,
      'end_bk' => params['event']['end'].to_date.yesterday
    ]
    @event_for_check = Ngevent.new(ngevent_params)
    unless @event_for_check.is_settable(params[:id], @ngevent.listing_id)
      return render json: { msg: 'ng date', event: @event_second }, status: 4003
    end
    respond_to do |format|
      if @ngevent.update(ngevent_params)
        format.html { redirect_to @ngevent, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @ngevent }
      else
        format.html { render :edit }
        format.json { render json: @ngevent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ngevents/1
  # DELETE /ngevents/1.json
  def destroy
    if @ngevent.mode == 1 || @ngevent.mode == 2
      return render json: { msg: 'ng date', event: @ngevent }, status: 4001
    end

    @ngevent.destroy
    respond_to do |format|
      #format.html { redirect_to ngevents_url, notice: 'Event was successfully destroyed.' }
      #format.json { head :no_content }
      format.json { return render json: { status: 'success', category: 'ngday' } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @ngevent = Ngevent.find(params[:id])
    end
end
