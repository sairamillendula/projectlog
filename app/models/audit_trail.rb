class AuditTrail < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  
  belongs_to :user
  attr_accessible :user_id, :action, :message
  
  def self.search(search)
    if search
      where('`audit_trails`.message LIKE ? OR `audit_trails`.action LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end
  
  def action_tag
    content_tag(:span, "#{action}", :class => "action #{action}")
  end
end
