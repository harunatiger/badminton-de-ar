include ActiveMerchant::Billing
module Payments
  def gateway
    @gateway ||= PaypalExpressGateway.new(
      :login => 'salonparu-facilitator_api1.gmail.com',
      :password => 'SN3GLNUM86SBGKRC',    
      :signature => 'AFcWxV21C7fd0v3bYYYRCpSSRl31AECo27pDqwd4TKHoUN8nIthar-6j')
  end
  
  def set_checkout(reservation)
    setup_response = self.gateway.setup_authorization(
            100000,
            :ip => request.remote_ip,
            :return_url => confirm_reservations_url,
            :cancel_return_url => cancel_reservations_url,
            :currency => 'JPY',
            items: item_params(reservation))
  end
  
  def item_params(reservation)
    [{name: reservation.listing.title,
      quantity: "1",
      amount: 100000}]
  end
  
  def purchase(reservation)
    response = process_purchase(reservation.payment)
    p response
    #transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    #cart.update_attribute(:purchased_at, Time.now) if response.success?
    response
  end

  def set_details(token)
    details = self.gateway.details_for(token)
  end

  private

  def process_purchase(payment)
    self.gateway.purchase(payment.amount, express_purchase_options(payment))
  end

  def standard_purchase_options
    {
      :ip => ip_address,
      :billing_address => {
        :name     => "Ryan Bates",
        :address1 => "123 Main St.",
        :city     => "New York",
        :state    => "NY",
        :country  => "US",
        :zip      => "10001"
      }
    }
  end

  def express_purchase_options(payment)
    {
      :ip => request.remote_ip,
      :token => payment.token,
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