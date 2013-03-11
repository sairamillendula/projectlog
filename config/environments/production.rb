Projectlog::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  # (comment out if your front-end server doesn't support this)
  config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # Use 'X-Accel-Redirect' for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  #config.assets.precompile += %w( login.css jquery.ui.theme.css )
  config.assets.precompile += %w( login.css public.css invoices.css jquery.ui.theme.css administr8te.css)

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Specify the default JavaScript compressor
  config.assets.js_compressor  = :uglifier

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Disable delivery errors, bad email addresses will be ignored
  #config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  config.action_mailer.default_url_options = { :host => 'projectlogapp.com' }
  config.action_mailer.asset_host = 'http://projectlogapp.com'
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp
  
  # Mail server
  config.action_mailer.smtp_settings = {
    :address              => ENV['PRJLOG_MAILSERVER_ADDRESS'],
    :port                 => ENV['PRJLOG_MAILSERVER_PORT'],
    :authentication       => ENV['PRJLOG_MAILSERVER_AUTHENTICATION'],
    :user_name            => ENV['PRJLOG_MAILSERVER_USERNAME'],
    :password             => ENV['PRJLOG_MAILSERVER_PASSWORD'],
    :domain               => ENV['PRJLOG_MAILSERVER_DOMAIN'],
    :openssl_verify_mode  => ENV['PRJLOG_MAILSERVER_OPENSSL_VERIFY_MODE'] == 'true',
    :enable_starttls_auto => ENV['PRJLOG_MAILSERVER_ENABLE_STARTTLS_AUTO'] == 'true'
  }

  config.middleware.use ExceptionNotifier,
    :email_prefix         => "[Exception]",
    :sender_address       => %{"Exception Notifier" <app@projectlogapp.com>},
    :exception_recipients => %w{alert@yafoy.com}

  # PayPal configuration
  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :production
    Subscription.gateway = ::ActiveMerchant::Billing::PaypalGateway.new(
      :login     => ENV['PRJLOG_PAYPAL_LOGIN'],
      :password  => ENV["PRJLOG_PAYPAL_PASSWORD"],
      :signature => ENV["PRJLOG_PAYPAL_SIGNATURE"]
    )
  end  
end