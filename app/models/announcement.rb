class Announcement < ActiveRecord::Base
  validates_presence_of :message, :starts_at, :ends_at
  validate :start_date_must_be_smaller_than_end_date
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
  
  def self.current_announcement_for(some_user)
    current_announcements.select { |a| !a.hidden_by?(some_user) }.first
  end

  def start_date_must_be_smaller_than_end_date
    if starts_at.present? && ends_at.present? && starts_at > ends_at
      errors.add(:starts_at, "must be smaller than end date")
    end
  end
  
end
