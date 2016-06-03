class StaticPagesController < ApplicationController
  def cancel_policy_en
  end

  def service_agreement_en
  end

  def specific_commercial_transactions_en
  end

  def privacy_policy_en
  end

  def cancel_policy_jp
  end

  def service_agreement_jp
  end

  def specific_commercial_transactions_jp
  end

  def privacy_policy_jp
  end

  def about
  end

  def lp01
  end
  
  def sign_up_form
    if request.xhr?
      render partial: 'shared/modals/sign_up_form', locals: {to_user_id: params[:to_user_id]}
    end
  end

end
