require 'fakeweb'
require 'hominid'

FakeWeb.allow_net_connect = false

RSpec.configure do |config|
  config.before(:each) do
    FakeWeb.clean_registry
    @valid_api_key = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-us1'
    @invalid_api_key = 'not_a_valid_api_key'
  end
end