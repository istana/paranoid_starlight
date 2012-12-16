# -*- coding: UTF-8 -*-

require "paranoid_starlight/version"
require 'active_model'
require 'twitter_cldr'
require 'fast_gettext'

module ParanoidStarlight

  module Validators
    class EmailValidator < ::ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        # username in email may have @ in string
        # username should be case sensitive, domain is not
        unless value =~ %r{\A([^\s]+)@((?:[-a-zA-Z0-9]+\.)+[a-zA-Z]{2,})\z}
          record.errors[attribute] << (options[:message] || 'is not an email')
        end
      end
    end
    
    class NameValidator < ::ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        fullname = '\p{Letter}+(-\p{Letter}+)*'
        surname = fullname
        short = '\p{Letter}\.'
        unless value =~ /\A(?:#{fullname} ((#{fullname}|#{short}) )*#{surname})\z/
          record.errors[attribute] << (options[:message] || 'is not a name')
        end
      end
    end
    
    class TelephoneValidator < ::ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        # SK/CZ format
        valid = ::ParanoidStarlight::Converters.convert_telephone(value) rescue nil 
        unless valid
          record.errors[attribute] << (options[:message] || 'is not a telephone number')
        end
      end
    end
  end # end validators
    
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
    
    
  module Converters
    def self.convert_telephone(num, prefixcc = 421)
      telephone = num.to_s
      prefixcc = prefixcc.to_s
      
      # convert logic
      # possible formats, with or without spaces
        
      # mobile (CZ/SK)
      # CZ/SK have always 9 numbers
      # (1) +421 949 123 456
      # (2) 00421 949 123 456
      # (3) 0949 123 456 (10 with leading zero, only SK)
      # (4) 949 123 456
      
      # landline always 9 numbers
      # other regions - 04x
      # (3) 045 / 6893121
      # bratislava - 02
      # (3) 02 / 44250320
      # (1) 421-2-44250320
      # (1) +421 (2) 44250320
      # (x) ()44 250 320 (no chance to guess NDC (geographic prefix here))
      # and other formats from above
      
        
      # output is integer
      # 421949123456
      
      # remove all non-number characters
      telephone.gsub!(/\D/, '')
      
      cc = '420|421'
      
      # + is stripped
      if match = /\A((?:#{cc})\d{9})\z/.match(telephone)
        return match[1]
      elsif match = /\A00((?:#{cc})\d{9})\z/.match(telephone)
        return match[1]
      elsif match = /\A0(\d{9})\z/.match(telephone)
        return prefixcc + match[1]
      # number cannot begin with 0, when has 9 numbers
      elsif match = /\A([1-9]\d{8})\z/.match(telephone)
        return prefixcc + match[1]
        
      else
        raise("Number is invalid")
      end
    end
  
    def convert_telephone_number(inattr, outattr = '')
      inattr = inattr.to_s
      outattr = outattr.to_s
      
      if self.respond_to? inattr.to_sym
        outattr = inattr if outattr == ''
        raise("Attribute #{outattr} does not exist.") unless self.respond_to? outattr.to_sym
        setter = "#{outattr}=".to_sym
        
        telephone = self.send(inattr.to_sym)

        num = ::ParanoidStarlight::Converters.convert_telephone(telephone, 
          TwitterCldr::Shared::PhoneCodes.code_for_territory(FastGettext.locale.to_sym)
        ) rescue nil
        
        self.send(setter, num) unless num.nil?
      else
        raise("Attribute #{inattr} does not exist.")
      end
    end
    
  end # end converters
end 
