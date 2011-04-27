class Activity < ActiveRecord::Base
  belongs_to :project
  default_scope order('date DESC')
  
  attr_accessible :date, :time, :description
end
