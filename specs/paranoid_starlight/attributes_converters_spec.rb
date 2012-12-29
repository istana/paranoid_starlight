require_relative '../spec_helper.rb'

class Fangirl
  include ::ParanoidStarlight::Attributes::Converters
  attr_accessor :telephone
  attr_accessor :text
  attr_accessor :basic_field, :basic_field2, :basic_field_out
end

describe ParanoidStarlight::Attributes::Converters do

  describe 'convert_telephone_number' do
    before :each do
      FastGettext.locale = 'sk'      
      @test = Fangirl.new
      @test.telephone = '+421 123 456 789'
    end
    
    it 'should convert telephone number into international format' do
      @test.convert_telephone_number(:telephone)
      
      @test.telephone.should == '+421123456789'
    end
  end
  
  describe 'process_string' do
    before { @test = Fangirl.new; @test.text = "  Some  \t\ntext.\n \t" }
    it 'should get string in one line separated with spaces' do
      @test.process_string(:text)
      @test.text.should == "Some text."
    end
  end

  describe 'template of converter' do
    before do
      @test = Fangirl.new
      @test.basic_field = "Hello world!"
      @test.basic_field2 = "World sends love to you!"
    
      def @test.upcase(input, output = '')
        basic_converter(self, input, output) do |text|
          text.upcase
        end
      end
    end
    
    context 'supplies parameters in different format' do
      it 'should accept anything in input with to_s' do
        @test.upcase(:basic_field)
        @test.basic_field.should == "HELLO WORLD!"
        
        @test.upcase('basic_field2')
        @test.basic_field2.should == "WORLD SENDS LOVE TO YOU!"
      end
      
      it 'should accept anything with to_s as output' do
        @test.upcase(:basic_field, :basic_field_out)
        @test.basic_field_out.should == "HELLO WORLD!"
        
        @test.upcase('basic_field2', 'basic_field_out')
        @test.basic_field_out.should == "WORLD SENDS LOVE TO YOU!"
      end
    end
    
    context 'had one attribute supplied' do
      it 'should overwrite attribute' do
        @test.upcase(:basic_field)
        
        @test.basic_field.should == "HELLO WORLD!"
      end
    end
    
    context 'had two attributes supplied' do
      it 'should put result to second attribute' do
        @test.upcase(:basic_field, :basic_field_out)
        
        @test.basic_field.should == "Hello world!"
        @test.basic_field_out.should == "HELLO WORLD!"
      end
    end
    
    context 'had array of attributes supplied' do
      it 'should convert all attributes of array' do
        @test.upcase([:basic_field, :basic_field2])
        
        @test.basic_field.should == "HELLO WORLD!"
        @test.basic_field2.should == "WORLD SENDS LOVE TO YOU!"
      end
    end
    
    context 'had array of attributes and output supplied' do
      it 'should raise error' do
        expect {@test.upcase([:basic_field, :basic_field2],
                 :basic_field_out) }.to raise_error(/Multiple attributes can/)
      end
    end
    
  end # end template of converter

end 
