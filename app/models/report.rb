# encoding: utf-8
class Report < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  validates_presence_of :start_date, :end_date, :user_id, :slug
  validate :start_date_must_be_smaller_than_end_date
  
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
  alias_method :total_hours, :total_time
  
  def project_title
    project.present? ? project.title : "All Projects"
  end
    
  def description
    "#{project_title} from #{I18n.l start_date, :format => :long} to #{I18n.l end_date, :format => :long}"
  end
  
  def approve!(ip_address)
    self.approved = true
    self.approved_at = Time.zone.now
    self.approved_ip = ip_address
  end
  
  private
  
  def generate_random_slug
    self.slug = Devise.friendly_token.downcase
  end
  
  def start_date_must_be_smaller_than_end_date
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:start_date, "must be smaller than end date")
    end
  end
  
  attr_protected :approved, :approved_at, :approved_ip
end
