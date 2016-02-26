Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store
  config.cache_store = :dalli_store,
   (ENV["MEMCACHIER_SERVERS"] || "").split(","),
   {:failover => true,
    :socket_timeout => 1.5,
    :socket_failure_delay => 0.2
   }

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like
  # NGINX, varnish or squid.
  config.action_dispatch.rack_cache = true
  config.middleware.use Rack::Cache,
    :verbose => true,
    :metastore   => 'file:/var/cache/rack/meta',
    :entitystore => 'file:/var/cache/rack/body'

  client = Dalli::Client.new((ENV["MEMCACHIER_SERVERS"] || "").split(","),
                           :failover => true,
                           :socket_timeout => 1.5,
                           :socket_failure_delay => 0.2,
                           :value_max_bytes => 10485760)
  config.action_dispatch.rack_cache = {
    :metastore    => client,
    :entitystore  => client
  }
  config.static_cache_control = "public, max-age=2592000"

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass

  config.assets.compile = false
  config.assets.digest = true
  config.assets.compress = true
  config.assets.debug = false

  # Specifies the header that your server uses for sending files.
  config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  #config.force_ssl = true
  #test

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Mailer Setting
  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true

  ## set your project mailer config below.
  ## config below is sample to use heroku addon 'SENDGRID'
  config.action_mailer.default_url_options = { :host => ENV['ELB_DOMAIN'] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => "heroku.com",
    :address        => "smtp.sendgrid.net",
    :port           => 25, # ssl:587, plain:25
    :authentication => :plain,
    :enable_starttls_auto => true
  }

  GA.tracker = "UA-54768854-8"

  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :production
    paypal_options = {
      login: Rails.application.secrets.paypal_express_user_name,
      password: Rails.application.secrets.paypal_express_user_password,
      signature: Rails.application.secrets.paypal_express_signature
    }
    ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
  end
end
