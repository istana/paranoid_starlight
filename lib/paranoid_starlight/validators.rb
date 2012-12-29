# -*- coding: UTF-8 -*-

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
        valid = ::ParanoidStarlight::Converters.telephone_will_convert?(value) 
        unless valid
          record.errors[attribute] << (options[:message] || 'is not a telephone number')
        end
      end
    end
  end # end validators
  
end 
