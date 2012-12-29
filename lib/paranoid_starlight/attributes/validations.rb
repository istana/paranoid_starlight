module ParanoidStarlight
  module Attributes
    module Validations
      def self.included(base)
        base.send(:extend, self)
      end
  
      def validates_email_format_of(*attr_names)
        # _merge_attributes extracts options and flatten attrs
        # :attributes => {attr_names} is lightweight option
        validates_with ::ParanoidStarlight::Validators::EmailValidator, _merge_attributes(attr_names)
      end
    
      def validates_name_format_of(*attr_names)
        validates_with ::ParanoidStarlight::Validators::NameValidator, _merge_attributes(attr_names)
      end
    
      def validates_telephone_number_of(*attr_names)
        validates_with ::ParanoidStarlight::Validators::TelephoneValidator, _merge_attributes(attr_names)
      end
    end # end validations
  end
end 
