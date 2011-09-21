class Emailing < ActiveRecord::Base
  attr_accessible :active, :description, :api_key, :list_key
end
