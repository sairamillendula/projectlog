class Activity < ActiveRecord::Base
  belongs_to :project
  
  attr_accessible :date, :time, :description, :project_id
  
  validates_numericality_of :time
  validates_presence_of :date, :time, :description, :project_id
  
  def self.search(search)
    if search
      where('"activities"."description" LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def self.after(some_date)
    where("date >= ?", some_date)
  end
  
  def self.before(some_date)
    where("date <= ?", some_date)
  end
  
  def self.belonging_to_projects(some_projects)
    some_projects = [some_projects] unless some_projects.is_a?(Array)
    where("project_id in (?)", some_projects.collect(&:id))
  end  
  
  def self.total_time
    sum(:time)
  end
  
  def self.total_time_grouped_by_date
    group("date").sum(:time)
  end
end
