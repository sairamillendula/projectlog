source 'http://rubygems.org'

gem 'rails', '3.1.1'

gem 'sass-rails'
gem 'coffee-script'
gem 'uglifier'
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


group :development do
  gem "letter_opener"
end

group :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem "mysql2" #Disable for now as I can't install it
  gem 'rb-fsevent'
  gem 'guard-livereload'
  gem 'mocha'
  gem 'therubyracer'
  gem 'spork-testunit'
end

# 3.1 Heroku
group :production do
  gem 'pg'
end