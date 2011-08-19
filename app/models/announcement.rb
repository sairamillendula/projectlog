class Announcement < ActiveRecord::Base
  validates_presence_of :message, :starts_at, :ends_at
  serialize :hidden_by_user_ids, Array
  
  default_scope :order => 'ends_at DESC'
  scope :current_announcements, lambda { where("starts_at <= ? AND ends_at >= ?", Time.zone.now, Time.zone.now) }
  
  def hidden_by?(user)
    hidden_by_user_ids.include?(user.id)
  end
  
  def hide_for!(user)
    hidden_by_user_ids << user.id
    hidden_by_user_ids.uniq!
    save!
  end
end
