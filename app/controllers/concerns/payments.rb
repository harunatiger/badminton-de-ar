include ActiveMerchant::Billing
module Payments
  def gateway
    @gateway ||= PaypalExpressGateway.new(
      :login => Rails.application.secrets.paypal_express_user_name,
      :password => Rails.application.secrets.paypal_express_user_password,    
      :signature => Rails.application.secrets.paypal_express_signature)
  end
  
  def set_checkout(reservation)
    host = User.find(reservation.host_id)
    description = 'ガイドID：' + host.id.to_s + ',ガイド名:' + host.profile.first_name + host.profile.last_name + ',振込先銀行口座'
    setup_response = self.gateway.setup_authorization(
            reservation.paypal_amount,
            :ip => request.remote_ip,
            :return_url => confirm_reservations_url,
            :cancel_return_url => cancel_reservations_url,
            :currency => 'JPY',
            no_shipping: 1,
            items: item_params(reservation))
  end
  
  def item_params(reservation)
    [{name: reservation.listing.title,
      quantity: "1",
      amount: reservation.paypal_amount}]
  end
  
  def purchase(payment)
    response = process_purchase(payment)
    p response
    response
  end
  
  def refund(payment)
    response = self.gateway.refund(nil,payment.transaction_id)
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
      :payer_id => payment.payer_id
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