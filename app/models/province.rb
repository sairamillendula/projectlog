class Province < ActiveRecord::Base
  
  attr_accessible :name, :short_name
  default_scope order('name')
  
end
