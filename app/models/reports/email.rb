class Reports::Email
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :to, :subject, :body, :from, :report_link, :reply_to
  
  validates_presence_of :to, :subject, :body, :from, :report_link
  validate :body_must_contain_report_link
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def body
    (@body || "").gsub("%{report_link}", report_link)
  end
  
  def deliver
    ReportsMailer.report_shared_with_you(self).deliver
  end
  
  def body_must_contain_report_link
    errors.add(:body, "must contain a link to the report") unless body.include?(report_link)
  end
  
  def persisted?
    false
  end  
end
