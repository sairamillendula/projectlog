require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Added to avoid 'could not parse YAML at line XX column XX'
require 'yaml'
YAML::ENGINE.yamler= 'syck'
