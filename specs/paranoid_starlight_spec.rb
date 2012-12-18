require_relative '../lib/paranoid_starlight'
require 'rspec'

#ActiveRecord::Base.send(:include, ParanoidStarlight::Validators)
#ActiveRecord::Base.send(:include, ParanoidStarlight::Converters)

class Fangirl
  include ::ParanoidStarlight::Converters
  attr_accessor :telephone_from_form, :telephone
  attr_accessor :text
end

describe ParanoidStarlight::Converters do
  before :all do
    @p = ParanoidStarlight::Converters
  end
  
  describe 'convert_telephone' do

    it 'accepts all objects, which have to_s' do
      ['421123456789',
       421123456789,
       :"421123456789"].each do |num|
        @p.convert_telephone(num).should == '421123456789'
      end
    end
    
    it 'removes non-numeric characters' do
      @p.convert_telephone(' +421 123 / 456789A').should == '421123456789'
    end
    
    it 'tests (un)polished valid formats' do
      ['+421 123 456 789',
       '00421 123 456 789',
       '123 456 789',
       '0123 456 789'].each { |num|
         @p.convert_telephone(num).should == '421123456789'
      }
      @p.convert_telephone('043/5867890').should == '421435867890'
    end
    
    it 'tests some of invalid formats' do
      ['043/586789',
       '123',
       '4211234567890'
      ].each { |num|
        expect {@p.convert_telephone(num)}.to raise_error('Number is invalid')
      }
    end
    
    it 'tests with custom country code prefix' do
      @p.convert_telephone('+421 123 456 789', 410).should == '421123456789'
      @p.convert_telephone('123 456 789', 410).should == '410123456789'
      @p.convert_telephone('0123 456 789', 410).should == '410123456789'
    end
    
  end
  
  describe 'convert_telephone_number (for attributes)' do
    before :each do
      FastGettext.locale = 'sk'      
      @test = Fangirl.new
      @test.telephone_from_form = '+421 123 456 789'
    end
    
    context 'with two parameters - input and output attribute' do
      it 'should store result in second parameter' do
        @test.convert_telephone_number(:telephone_from_form, :telephone)
        @test.telephone.should == '421123456789'
      end
    end
    
    context 'with only one parameter' do
      it 'should convert telephone number and overwrite original' do
        @test.convert_telephone_number(:telephone_from_form)
        @test.telephone_from_form.should == '421123456789'
      end
    end
  end
  
  describe 'clean_text (for attributes)' do
    before { @test = Fangirl.new; @test.text = "  Some  \ttext. \t" }
    it 'should clean text of unneccessary characters' do
      @test.clean_text(:text)
      @test.text.should == "Some text."
    end
  end
end
  
describe 'ParanoidStarlight::Validations' do
  before(:each) do
    @validators = ParanoidStarlight::Validators
    
    @mock = mock('model')
    @mock.stub("errors").and_return([])
    @mock.errors.stub('[]').and_return({})  
    @mock.errors[].stub('<<')
  end
    
    describe 'EmailValidator' do
      before :each do
        @email = @validators::EmailValidator.new({:attributes => {}})
      end
      
      it "should validate valid email address" do
        @mock.should_not_receive('errors')
        @email.validate_each(@mock, "email", "example@example.org")
        @email.validate_each(@mock, "email", "example@@example.org")
        @email.validate_each(@mock, "email", "l0~gin@sub.examp-le.org")
      end

      it "should validate invalid email address" do
        @mock.errors[].should_receive('<<')
        @email.validate_each(@mock, "email", "notvalid")
        @email.validate_each(@mock, "email", "x@exa$mple.org")
      end
    end  
    
    describe 'NameValidator' do
      before :each do
        @name = @validators::NameValidator.new({:attributes => {}})
      end
      
      it "should validate valid name" do
        @mock.should_not_receive('errors')
        [
          'Ivan Stana', 'Ivan R. Stana', 'Ivan Ronon Stana',
          'Jean Claude Van Damme', 'Jean-Pierre Cassel',
          'Tatyana Sukhotina-Tolstaya',
          'John R. R. Tolkien'
        ].each {
          |name| @name.validate_each(@mock, "name", name)
        }
      end

      it "should validate invalid name" do
        @mock.errors[].should_receive('<<')
        [
          'J. R. R. Tolkien', 'J.R.R. Tolkien', 'Tolkien'
        ].each {
          |name| @name.validate_each(@mock, "name", name)
        }
      end
    end 
    
    describe 'TelephoneValidator' do
      before :each do
        @telephone = @validators::TelephoneValidator.new({:attributes => {}})
      end
      
      it "should validate valid telephone" do
        @mock.should_not_receive('errors')
        @telephone.validate_each(@mock, "telephone", '+421123456789')
      end
    
      it "should validate invalid telephone" do
        @mock.errors[].should_receive('<<')
        @telephone.validate_each(@mock, "telephone", '123')
      end
    end

    describe 'model Validators of' do
      class TestEmail
        include ActiveModel::Validations
        include ParanoidStarlight::Validations
        attr_accessor :email_field
        validates_email_format_of :email_field
      end
    
      class TestName
        include ActiveModel::Validations
        include ParanoidStarlight::Validations
        attr_accessor :name_field
        validates_name_format_of :name_field
      end
      
      class TestName
        include ActiveModel::Validations
        include ParanoidStarlight::Validations
        attr_accessor :name_field
        validates_name_format_of :name_field
      end
      
      class TestTelephone
        include ActiveModel::Validations
        include ParanoidStarlight::Validations
        attr_accessor :telephone
        validates_telephone_number_of :telephone
      end
      # I don't test multiple attributes as argument
      # it works, because it is copied from rails
      
      
      describe 'Email' do
        subject { TestEmail.new() }
        
        before { subject.email_field = email_value }
        
        context 'is valid' do
          let(:email_value) {'example@my.example.org'}
          it {should be_valid }
        end
        
        context 'is invalid' do
          let(:email_value) {'example'}
          it { should be_invalid }
        end
      end
      
      describe 'Name' do
        subject { TestName.new() }
        
        before do
          subject.name_field = name
        end
        
        context 'is valid' do
          let(:name) {'Geralt of Rivia'}
          it { should be_valid }
        end
        
        context 'is invalid' do
          let(:name) {'Shakespeare'}
          it { should be_invalid }
        end
      end
      
      describe 'Telephone' do
        subject { TestTelephone.new() }
        
        before do
          subject.telephone = telephone
        end
        
        context 'is valid' do
          let(:telephone) {'+421123456789'}
          it { should be_valid }
        end
        
        context 'is invalid' do
          let(:telephone) {'1111'}
          it { should be_invalid }
        end
      end
            
    end
  
end # end validations
