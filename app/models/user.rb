class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  
  after_create :build_profile
  
  has_one :profile, :dependent => :destroy
  has_many :customers, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :connections, :through => :customers, :source => :contacts
  has_many :activities, :through => :projects
  
  
  # Devise change to allow users edit their accounts without providing a password
  def password_required?
    new_record?
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
private
  def build_profile
    logger.debug "It's time to create the account."
       self.create_profile
    logger.debug "The account should be created now."
  end
  
end
