include ActiveMerchant::Billing
module Payments
  def gateway
    @gateway = EXPRESS_GATEWAY
  end

  def set_checkout(reservation)
    setup_response = self.gateway.setup_authorization(
            reservation.paypal_amount,
            :ip => request.remote_ip,
            :return_url => confirm_payment_reservations_url,
            :cancel_return_url => cancel_payment_reservations_url,
            :currency => 'JPY',
            description: reservation.listing.title,
            no_shipping: 1,
            items: item_params(reservation))
  end

  def item_params(reservation)
    if reservation.campaign.present?
      [{name: reservation.listing.title,
        amount: reservation.paypal_sub_total},
        {name: 'Service commission',
        amount: reservation.paypal_handling_cost},
        {name: 'Discount',
          amount: reservation.paypal_campaign_discount}]
    else
      [{name: reservation.listing.title,
        amount: reservation.paypal_sub_total},
        {name: 'Service commission',
        amount: reservation.paypal_handling_cost}]
    end
  end

  def do_purchase(payment)
    response = process_purchase(payment)
    p response
    response
  end
  
  def refund(payment, reservation)
    if reservation.before_weeks?
      response = refund_full(payment)
    elsif reservation.before_days?
      response = refund_partial(payment, Settings.payment.refunds.before_days_rate)
    end
    p response
    response
  end

  def refund_full(payment)
    response = self.gateway.refund(nil, payment.transaction_id, {refund_type: 'Full', currency: 'JPY'} )
  end
  
  def refund_partial(payment, percentage)
    response = self.gateway.refund(payment.refund_amount_for_paypal(percentage), payment.transaction_id, {refund_type: 'Partial', currency: 'JPY'} )
  end

  def set_details(token)
    details = self.gateway.details_for(token)
  end

  private

  def process_purchase(payment)
    self.gateway.purchase(payment.amount_for_paypal, express_purchase_options(payment))
  end

  def express_purchase_options(payment)
    if Rails.env.production?
      {
        :ip => request.remote_ip,
        :token => payment.token,
        :currency => 'JPY',
        :payer_id => payment.payer_id,
        :items => item_params(payment.reservation)
      }
    else
      {
        :ip => request.remote_ip,
        :token => payment.token,
        :currency => 'JPY',
        :payer_id => payment.payer_id
      }
    end
  end
end