# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
ActiveMerchant::Billing::PaypalExpressGateway.default_currency = "JPY"
