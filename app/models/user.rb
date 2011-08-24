class User < ActiveRecord::Base
  include ActiveModel::Dirty
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name,
                  :created_at, :updated_at, :last_sign_in_at, :current_sign_in_ip, :sign_in_count, :plan_id

  validates_confirmation_of :password
  validates_presence_of :first_name, :last_name
  
  after_create :build_profile_and_set_default_plan
  
  has_one  :profile, :dependent => :destroy
  has_many :projects, :dependent => :destroy, :order => 'created_at DESC'
  has_many :customers, :dependent => :destroy  
  has_many :connections, :through => :customers, :source => :contacts
  has_many :activities, :through => :projects
  has_many :reports, :dependent => :destroy
  has_many :invoices, :dependent => :destroy
  belongs_to :plan
  
  scope :standard, where(:admin => false)
  scope :admin, where(:admin => true)
  scope :with_free_plan, joins(:plan).where("plans.name = ?", "Free")
  scope :with_paid_plan, joins(:plan).where("plans.name != ?", "Free")
  
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
  
  def self.search(search)
    if search
      where('`users`.first_name LIKE ? OR `users`.last_name LIKE ?', "%#{search}%", "%#{search}%")
    else
      scoped
    end
  end
  
  
private
  def build_profile_and_set_default_plan
    logger.debug "It's time to create the account."
       self.create_profile
    logger.debug "The account should be created now."
    
    logger.debug "It's time to select a plan."
       self.update_attributes(:plan_id => Plan.find_by_name!("Free").id)
    logger.debug "Default plan should be added."
  end
  
  def self.count_on(date)
    where("date(created_at) = ?", date).count(:id)
  end
  
end