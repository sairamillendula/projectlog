source 'http://rubygems.org'

gem 'rails', '3.1.1'

gem 'sass-rails'
gem 'coffee-script'
gem 'uglifier'

gem 'prawn_rails'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'devise'
gem 'heroku'
gem 'jquery-rails'
gem 'tabs_on_rails'
gem 'kaminari'
gem 'pdfkit'
gem 'wkhtmltopdf-binary'
gem 'rails-settings', :git => 'git://github.com/100hz/rails-settings.git'
gem 'redcarpet'
gem 'google_visualr', '~> 2.1'
gem 'bourbon'
gem 'cancan', :git => 'git://github.com/ryanb/cancan.git'
gem 'clarity'
gem 'money'
gem 'nested_form', :git => "git://github.com/ryanb/nested_form.git"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:

group :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem "mysql2" #Disable for now as I can't install it
  gem 'rb-fsevent'
  gem 'guard-livereload'
  gem 'mocha'
  gem 'therubyracer'
end

# 3.1 Heroku
group :production do
  gem 'pg'
end