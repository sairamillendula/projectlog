require 'spec_helper'

module Hominid
  describe API do

    it "requires an API key" do
      expect {Hominid::API.new}.should raise_error(ArgumentError)
    end
    
    it "requires a valid API key" do
      expect {Hominid::API.new(@invalid_api_key)}.should raise_error(ArgumentError)
    end

    it "also accepts config options" do
      expect {Hominid::API.new(@validapi_key, {:secure => true})}.should_not raise_error(ArgumentError)
    end
    
    # TODO: Need a way to mock XMLRPC requests.

  end
end
