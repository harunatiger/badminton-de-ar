class StaticPagesController < ApplicationController
  before_action :set_html, only: [:plan4U, :plan4U_kyoto]
  
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

  def plan4U
  end

  def plan4U_kyoto
  end

  def three_reasons
  end

  def our_partners
  end
  
  private
  def set_html
    @s3_header = File.read(Rails.root.join('public/s3_contents/plan4U_header.html'))
    @s3_middle = File.read(Rails.root.join('public/s3_contents/plan4U_middle.html'))
    @s3_footer = File.read(Rails.root.join('public/s3_contents/plan4U_footer.html'))
  end

end
