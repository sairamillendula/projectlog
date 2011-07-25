class Report < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  validates_presence_of :start_date, :end_date, :user_id, :slug
  
  before_validation :generate_random_slug, :on => :create
  
  def to_param
    slug
  end
  
  def activities
    user.activities.after(start_date).before(end_date).belonging_to_projects(projects)
  end
  
  def projects
    project.present? ? [project] : user.projects
  end
  
  def total_time
    activities.sum(:time)
  end
  
  def project_title
    project.present? ? project.title : "All Projects"
  end
    
  def description
    "#{project_title} from #{I18n.l start_date, :format => :long} to #{I18n.l end_date, :format => :long}"
  end
  
  private
  
  def generate_random_slug
    self.slug = SecureRandom.hex(10)
  end
  
end
