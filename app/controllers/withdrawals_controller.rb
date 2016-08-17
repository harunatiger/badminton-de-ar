class WithdrawalsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    withdrawals = current_user.withdrawals
    @credit = withdrawals.credit.first
    @requests = withdrawals.requests.order_by_requested_at_desc
    @histories = withdrawals.histories.order_by_created_at_desc
    @paid_in_two_weeks = @histories.paid_in_two_weeks.order_by_paid_at_desc
    @histories = @histories.where.not(id: @paid_in_two_weeks.ids) if @paid_in_two_weeks.present?
  end
  
  def apply
    withdrawals = current_user.withdrawals
    credit = withdrawals.credit.first
    
    if credit.update(requested_at: Time.zone.now)
      redirect_to withdrawals_path, notice: Settings.withdrawal.request.success
    else
      redirect_to withdrawals_path, alert: Settings.withdrawal.request.failure
    end
  end
end
