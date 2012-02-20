class Emailing < ActiveRecord::Base
  attr_accessible :active, :description, :api_key, :list_key
  scope :active, where(:active => true)
  
  validates_presence_of :description, :api_key
end
