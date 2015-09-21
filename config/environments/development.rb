Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false
  config.assets.compress = true       # serve assets as .gz
  config.assets.compile = true       # live compile
  config.assets.digest = true        # add md5 value on every static file
  config.serve_static_files = true 

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # gem bullet
  config.after_initialize do
    Bullet.enable = true # Bulletプラグインを有効
    Bullet.alert = true # JavaScriptでの通知
    Bullet.bullet_logger = true # log/bullet.logへの出力
    Bullet.console = true # ブラウザのコンソールログに記録
    Bullet.rails_logger = true # Railsログに出力
  end

  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true

  # Mailer Setting
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    #:enable_starttls_auto => false,
    :address => 'smtp.gmail.com',
    #:address => 'localhost', for mailcatcher
    :port => 587,
    #:port => 1025, for mailcatcher
    :domain => 'gmail.com',
    :authentication => :plain,
    :user_name => Rails.application.secrets.action_mailer_user_name,
    :password => Rails.application.secrets.action_mailer_password
  }

  config.action_controller.action_on_unpermitted_parameters = :raise
  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
  end

end
