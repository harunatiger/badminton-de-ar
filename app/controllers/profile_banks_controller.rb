class ProfileBanksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile_bank, only: [:show, :edit, :update, :destroy]
  before_action :set_profile
  
  def index
    @profile_bank = ProfileBank.all
  end

  def show
  end

  def new
    @profile_bank = ProfileBank.new
  end

  def edit
  end

  def create
    @profile_bank = ProfileBank.new(profile_bank_params)
    respond_to do |format|
      if @profile_bank.save
        format.html { redirect_to profile_path(@profile.id), notice: Settings.profile_banks.save.success }
        format.json { render :show, status: :created, location: @profile_bank }
      else
        format.html { render :new }
        format.json { render json: @profile_bank.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @profile_bank.update(profile_bank_params)
        format.html { redirect_to profile_path(@profile.id), notice: Settings.profile_banks.save.success }
        format.json { render :show, status: :ok, location: @profile_bank }
      else
        format.html { render :edit}
        format.json { render json: @profile_bank.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @profile_bank.destroy
    respond_to do |format|
      format.html { redirect_to profile_bank_url, notice: 'Profile bank was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_bank
      @profile_bank = ProfileBank.find(params[:id])
    end

    def set_profile
      @profile = Profile.find(params[:profile_id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_bank_params
      params.require(:profile_bank).permit(:user_id, :profile_id, :name, :branch_name, :account_type, :user_name, :number)
    end
end
