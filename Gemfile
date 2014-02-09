source 'http://rubygems.org'

gem 'rails', '3.2.16'

gem 'mysql2'
gem 'devise'
gem 'jquery-rails', '~>2.0.1'
gem 'tabs_on_rails'
gem 'kaminari'
gem 'pdfkit'
gem 'wkhtmltopdf-binary'
gem 'rails-settings', github: 'renderedtext/rails-settings'
gem 'redcarpet'
gem 'google_visualr', '~> 2.1'
gem 'bourbon'
gem 'cancan', :git => 'git://github.com/ryanb/cancan.git'
gem 'clarity'
gem 'money'
gem 'nested_form', :git => 'git://github.com/ryanb/nested_form.git'
gem 'hominid'
gem 'capistrano', '~> 2.15.0'
gem 'activemerchant', :require => 'active_merchant', :git => 'git://github.com/Shopify/active_merchant.git'
gem 'paypal_pro_recurring', :git => 'git://github.com/olimart/paypal_pro_recurring.git'
gem 'whenever', '=0.8.0', :require => false
gem 'paperclip'

group :assets do
  gem 'sass-rails', "~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
end 

group :development do
  gem 'letter_opener'
end

group :development, :test do
  gem 'timecop'
  gem 'bullet'
  gem 'thin'
end

group :production do
  gem 'exception_notification'
  gem 'unicorn'
end