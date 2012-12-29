module ParanoidStarlight
  module Converters
    def convert_telephone(num, prefixcc = 421)
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
      
        
      # output is string
      # +421949123456
      # make integer from it call with to_i
      
      # remove all non-number characters
      # I don't care for alphabetic or special characters
      # in number
      telephone.gsub!(/\D/, '')
      
      cc = '420|421'

      # + is stripped in all numbers
      if match = /\A((?:#{cc})\d{9})\z/.match(telephone)
        number = match[1]
      elsif match = /\A00((?:#{cc})\d{9})\z/.match(telephone)
        number = match[1]
      elsif match = /\A0(\d{9})\z/.match(telephone)
        number = prefixcc + match[1]
      # number cannot begin with 0, when has 9 numbers
      elsif match = /\A([1-9]\d{8})\z/.match(telephone)
        number = prefixcc + match[1]
        
      else
        raise("Number is invalid")
      end
      
      '+' + number
    end
    
    # There will be no .valid? function
    # because it would need to handle number separators
    # and other characters in harder way.
    #
    # This number needs to be converted  to international format
    # before using it!
    
    def telephone_will_convert?(telephone)
      valid = convert_telephone(telephone) rescue nil
      valid.nil? ? false : true 
    end
    
    def one_liner(input)
      input.to_s.strip.gsub(/\s+/m, ' ')
    end
    
    # make methods also acessible with direct call
    module_function :convert_telephone, :telephone_will_convert?, :one_liner
    public :convert_telephone, :telephone_will_convert?, :one_liner 
    
  end # end converters

end 
