require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end


module Projectlog
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    config.active_record.observers = :user_observer, :payment_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = "en-US"
    config.i18n.fallbacks = true

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :card_code, :card_number]

    # SSL: Off in Dev, On in Test & Prod
    config.force_ssl = false

    # Devise Layout
    config.to_prepare do
      Devise::SessionsController.layout "login"
      Devise::RegistrationsController.layout proc { |controller| user_signed_in? ? "application" : "login" }
      Devise::ConfirmationsController.layout "login"
      Devise::UnlocksController.layout "login"
      Devise::PasswordsController.layout "login"
    end

    # Enable the asset pipeline
    config.assets.enabled = true
    
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    #config.middleware.use "PDFKit::Middleware", :print_media_type => true

    config.assets.initialize_on_precompile = false
  end
end
