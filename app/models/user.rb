class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name,
                  :created_at, :updated_at, :last_sign_in_at, :current_sign_in_ip, :sign_in_count
  
  after_create :build_profile
  
  has_one :profile, :dependent => :destroy
  has_many :customers, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :connections, :through => :customers, :source => :contacts
  has_many :activities, :through => :projects
  has_many :reports, :dependent => :destroy
  has_many :invoices, :dependent => :destroy
  
  scope :standard, where(:admin => false)
  scope :admin, where(:admin => true)
  
  # Devise change to allow users edit their accounts without providing a password
  def password_required?
    new_record?
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  alias_method :name, :full_name
  
  def name_with_email
    "#{full_name} <#{email}>"
  end
  
private
  def build_profile
    logger.debug "It's time to create the account."
       self.create_profile
    logger.debug "The account should be created now."
  end
  
end