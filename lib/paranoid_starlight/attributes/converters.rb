module ParanoidStarlight
  module Attributes
    module Converters
    
      def convert_telephone_number(inattr, outattr = '')
        basic_converter(self, inattr, outattr) do |telephone|
          ::ParanoidStarlight::Converters.convert_telephone(
            telephone, 
            TwitterCldr::Shared::PhoneCodes.code_for_territory(
              FastGettext.locale.to_sym
            )
          ) rescue nil
        end
      end
      
      # currently it only processes whitespaces
      def process_string(inattr, outattr = '')
        basic_converter(self, inattr, outattr) do |text|
          ::ParanoidStarlight::Converters.one_liner(text)
        end
      end
=begin
no purpose, needs improvement
      def remove_whitespaces(inattr, outattr = '')
        basic_converter(self, inattr, outattr) do |text|
          array = text.to_s.strip.split("\n")
          array.map {|line| line.gsub(/\s/, '')}.join("\n")
        end
      end
=end
    
      def basic_converter(obj, inattr, outattr, &code)
        attributes = []
      
        # May be only one value, ideally string or symbol
        outattr = outattr.to_sym
      
        if inattr.is_a? Array
          attributes = inattr
        elsif obj.respond_to? inattr.to_sym
          attributes << inattr
          # hash, array and like haven't got to_sym defined
          outattr = inattr if outattr.to_s == ''
        else
          raise("Attribute #{inattr} does not exist.")
        end
      
        if attributes.size > 1 && outattr.to_s != ''
          raise("Multiple attributes can be used only without output attribute")
        end
      
        attributes.each do |attribute|
          outattr = attribute if attributes.size > 1
        
          unless obj.respond_to? outattr
            raise("Attribute #{outattr} does not exist.")
          end
      
          setter = "#{outattr}=".to_sym
          unless obj.respond_to? setter
            raise("Setter #{setter} does not exist.")
          end
      
          to_convert = obj.send(attribute.to_sym)
          unless to_convert.nil?
            obj.send(setter, code.call(to_convert))
          end
        end
      end
    
    end
  end
end 
