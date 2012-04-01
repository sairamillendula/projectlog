class Plan < ActiveRecord::Base
  has_many :users, :dependent => :restrict
  
  attr_accessible :name, :description, :features, :price, :active, :displayable, :frequency
  validates_presence_of :name, :price, :description, :features, :active
  validates_uniqueness_of :name
  attr_accessor :perms
  
  scope :active, where(:active => true)
  scope :displayable, where(:displayable => true)
  scope :free, find_by_name("free")
  
  FREQUENCY = ['Month']
  
  def can_be_destroyed?
    users.count == 0
  end
  
  def max_plan?
    max_plan = Plan.active.order('price DESC').first
    self == max_plan
  end
  
  def costing?
    price > 0
  end
  
  # return a hash of permissions based on configured features
  # 
  # {
  #   :model_name => {
  #     :limit => <number>,
  #     :accessible => <boolean>
  #   }
  # }
  def permissions
    if @perms.blank?
      @perms = {}
      unless features.blank?
        arr = features.split(/\n/)
        arr.each do |perm|
          # make sure permission has correct format <limit|accessible> <model classname>
          matches = perm.strip.match /^(?<limit>\d+|YES|NO)\s+(?<model>Projects|Invoices|Transactions)$/
          unless matches.blank?
            limit = -1
            accessible = false
            if matches[:limit].to_i > 0
              limit = matches[:limit].to_i
              accessible = true
            else
              accessible = matches[:limit] == "YES"
            end
            @perms[matches[:model].singularize.downcase.to_sym] = {limit: limit, accessible: accessible}
          else
            raise "Invalid features format, valid format: <limit|accessible> <model classname>"
          end
        end
      else
        raise "Features is not configured"
      end
    end
    return @perms
  end

end
