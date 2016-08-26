include ActiveMerchant::Billing
module Payments
  def gateway
    @gateway = EXPRESS_GATEWAY
  end
  
  def refund_full(payment)
    response = self.gateway.refund(nil, payment.transaction_id, {refund_type: 'Full', currency: payment.currency_code} )
  end
end