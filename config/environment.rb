# Load the rails application
require File.expand_path('../application', __FILE__)
require 'newrelic_rpm'

# Initialize the rails application
Projectlog::Application.initialize!
