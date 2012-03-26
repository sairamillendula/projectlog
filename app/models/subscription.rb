class Subscription < ActiveRecord::Base
  include PaypalProRecurring::Subscribable
  
  belongs_to :plan
  belongs_to :user
  has_many :subscription_transactions
  
  attr_accessor :card_name, :card_number, :card_code, :card_expiration, :do_validate_card
  
  validates :plan_id, :card_name, :card_number, :card_code, :card_expiration, :presence => true, :if => Proc.new{|s| !s.do_validate_card.blank?}
  after_validation :generate_slug
  before_create :extract_card_type
  
  def to_param
    slug
  end
  
  def activate
    # TODO: send email
    self.active = true
    self.save!
    user.current_subscription = self
    user.plan_id = self.plan_id
    user.save!
  end
  
  def deactivate
    # TODO: send email
    # revert to free plan
    self.active = false
    self.save!
    
    user.plan_id = Plan.find_by_name("Free").id
    user.save!
  end
  
  def handle_gateway_response(subscription, request_type, response_type, response)
    puts "Request #{request_type}"
    puts response.inspect
  end
  
  def credit_card
    credit_card = ActiveMerchant::Billing::CreditCard.new(
      :first_name         => card_name.strip.split(/\s+/).first,
      :last_name          => card_name.strip.split(/\s+/).last,
      :number             => card_number,
      :month              => card_expiration['month'],
      :year               => card_expiration['year'],
      :verification_value => card_code)
  end
  
  def profile_options
    generate_slug
    opts = {
      :currency => "USD",
      :credit_card => credit_card,
      :amount => plan.price * 100, # amount in cents
      :start_date => start_date.nil? ? Time.now : start_date,
      :profile_reference => slug,
      :description => plan.description,
      :period => plan.frequency,
      :frequency => 1,
      :email => user.email,
      :max_failed_payments => Settings['max_failed_payments'],
      :auto_bill_outstanding => Settings['auto_bill_outstanding']
    }
  end
  
  private
  
  def extract_card_type
    cc = credit_card
    cc.valid? # let active merchant determine credit card type for us
    self.card_type = cc.type
    self.currency = "USD"
  end
  
  def generate_slug
    self.slug = Devise.friendly_token.downcase if slug.nil?
  end
end
