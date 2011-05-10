class Activity < ActiveRecord::Base
  belongs_to :project
  
  attr_accessible :date, :time, :description
  
  validates_numericality_of(:time)
  
  def self.search(search)
    if search
      where('description LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
end
