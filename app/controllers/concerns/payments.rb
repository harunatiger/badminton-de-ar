include ActiveMerchant::Billing
module Payments
  def gateway
    @gateway ||= PaypalExpressGateway.new(
      :login => Rails.application.secrets.paypal_express_user_name,
      :password => Rails.application.secrets.paypal_express_user_password,    
      :signature => Rails.application.secrets.paypal_express_signature)
  end
  
  def set_checkout(reservation)
    setup_response = self.gateway.setup_authorization(
            reservation.paypal_amount,
            :ip => request.remote_ip,
            :return_url => confirm_reservations_url,
            :cancel_return_url => cancel_reservations_url,
            :currency => 'JPY',
            description: reservation.listing.title,
            no_shipping: 1,
            items: item_params(reservation))
  end
  
  def item_params(reservation)
    if reservation.campaign.present?
      [{name: reservation.listing.title,
        amount: reservation.paypal_sub_total},
        {name: 'Service fee',
        amount: reservation.paypal_handling_cost},
        {name: 'キャンペーン値引き',
          amount: reservation.paypal_campaign_discount}]
    else
      [{name: reservation.listing.title,
        amount: reservation.paypal_sub_total},
        {name: 'Service fee',
        amount: reservation.paypal_handling_cost}]
    end
  end
  
  def purchase(payment)
    response = process_purchase(payment)
    p response
    response
  end
  
  def refund(payment, reservation)
    #note = Settings.payment.refunds.policy
    if reservation.before_weeks?
      response = self.gateway.refund(nil, payment.transaction_id, {refund_type: 'Full', currency: 'JPY'} )
    elsif reservation.before_days?
      response = self.gateway.refund(payment.refund_amount_for_paypal(50), payment.transaction_id, {refund_type: 'Partial', currency: 'JPY'} )
    end
    p response
    response
  end

  def set_details(token)
    details = self.gateway.details_for(token)
  end

  private

  def process_purchase(payment)
    self.gateway.purchase(payment.amount_for_paypal, express_purchase_options(payment))
  end

  def express_purchase_options(payment)
    {
      :ip => request.remote_ip,
      :token => payment.token,
      :currency => 'JPY',
      :payer_id => payment.payer_id,
      items: item_params(payment.reservation)
    }
  end

  def validate_card
    if express_token.blank? && !credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
    end
  end
  
end