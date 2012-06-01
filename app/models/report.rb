# encoding: utf-8
class Report < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  
  attr_accessible :project_id, :start_date, :end_date, :slug, :approved, :approved_at, :approved_ip, :user_id
  validates_presence_of :user_id, :slug
  validate :start_date_must_be_smaller_than_end_date
  
  before_validation :generate_random_slug, :on => :create
  
  def to_param
    slug
  end
  
  def activities
    scoped = user.activities
    scoped = scoped.after(start_date) if start_date.present?
    scoped = scoped.before(end_date) if end_date.present?
    scoped.belonging_to_projects(projects)
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
    arr = [project_title]
    arr << "from #{I18n.l start_date, :format => :long}" if start_date.present?
    arr << "to #{I18n.l end_date, :format => :long}" if end_date.present?
    arr.join(" ")
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
    if start_date.blank? && end_date.blank?
      errors.add(:base, "Start date or end date must be specified")
    else
      if start_date.present? && end_date.present? && start_date > end_date
        errors.add(:start_date, "must be smaller than end date")
      end
    end
  end

end
