module Taxable
  module ClassMethods
    
  end
  
  module InstanceMethods
    def tax1_name
      if tax1_label.blank? then
        "Tax 1 (#{tax1}%)"
      else
        "#{tax1_label} (#{tax1}%)"
      end
    end

    def tax2_name
      if tax2_label.blank? then
        "Tax 2 (#{tax2}%)"
      else
        "#{tax2_label} (#{tax2}%)"
      end
    end
    
    def any_taxes?
      !(tax1.blank? && tax2.blank?)
    end
    
    def tax_options
      taxes = [["No tax", 0]]
      taxes << [tax1_name, 1] unless tax1.blank?
      taxes << [tax2_name, 2] unless tax2.blank?
      taxes << ["Both", 3] unless tax1.blank? || tax2.blank?
      taxes
    end
    
    def copy_tax_setting(profile)
      self.tax1       = profile.tax1
      self.tax1_label = profile.tax1_label
      self.tax2       = profile.tax2
      self.tax2_label = profile.tax2_label
      self.compound   = profile.compound
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end