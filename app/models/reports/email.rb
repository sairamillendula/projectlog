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
  
  def persisted?
    false
  end
  
  def self.list_of_names_with_emails_regexp
    # Matches a list of names with emails. For example:
    # 'Andrés Mejía <andmej@gmail.com>,   Olivier SIMART <olivier.simart@gmail.com>, olivier@koopon.ca'
    /\A(#{name_with_email_regexp},\s*)*#{name_with_email_regexp}\z/
  end
  
  def self.email_regexp
    # Matches an email address. (Stolen from Devise)
    /([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})/i
  end
  
  def self.name_with_email_regexp
    # Matches 'Andrés Mejía <andmej@gmail.com>' or 'andmej@gmail.com', but doesn't match 'Andrés Mejía'
    /(((\S+\s*)+<#{email_regexp}>)|(#{email_regexp}))/    
  end
end
