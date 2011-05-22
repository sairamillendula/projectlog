class ProjectStatus < ActiveRecord::Base

  #has_many :projects

  attr_accessible :name, :position
  validates :name, :presence => true, :uniqueness => true
  validates :position, :presence => true, :numericality => true

  default_scope order(:position)

end
