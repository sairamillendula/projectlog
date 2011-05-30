class Reports::Email
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  attr_accessor :to, :subject, :body, :from, :report_link
  
  validates_presence_of :to, :subject, :body, :from, :report_link
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def deliver
    ReportsMailer.report_shared_with_you(self).deliver
  end
  
  def persisted?
    false
  end  
end
