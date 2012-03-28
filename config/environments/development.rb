Projectlog::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Dev Host
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Getprojectlog Email server setup
  # config.action_mailer.delivery_method = :smtp
  #     ActionMailer::Base.smtp_settings = {  
  #       :address              => "mail.projectlogapp.com",  
  #       :port                 => 587,
  #       :user_name            => "notifications+projectlogapp.com",  
  #       :password             => "10eytd10",  
  #       :authentication       => "plain",  
  #       :enable_starttls_auto => false
  #     }
  config.action_mailer.delivery_method = :letter_opener
  
  # Used by the letter_opener gem to show email in browser
  #config.action_mailer.delivery_method = :letter_opener
  
  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # fallback to assets pipeline if a precompiled asset is missed
  #config.assets.compile = true
  
  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5
  
  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
    Subscription.gateway = ::ActiveMerchant::Billing::PaypalGateway.new(
      :login => 'prjlog_1331871911_biz_api1.gmail.com',
      :password => '1331871950',
      :signature => 'APDXJuwGmrXuWJcwdRwbRiLlrW3nAibm4f9FKdxjDJcZ73gl-KQMJABX'
    )
  end
end