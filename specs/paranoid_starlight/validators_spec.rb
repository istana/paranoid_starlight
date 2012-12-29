require_relative '../spec_helper.rb'

describe ParanoidStarlight::Validators do
  before :all do
    @validators = ParanoidStarlight::Validators
  end
  
  before :each do
    @mock = mock('model')
    @mock.stub("errors").and_return([])
    @mock.errors.stub('[]').and_return({})  
    @mock.errors[].stub('<<')
  end
  
  describe 'EmailValidator' do
    before :each do
      @email = @validators::EmailValidator.new({:attributes => {}})
    end
      
    it "shouldn't add message to errors when valid email address" do
      @mock.should_not_receive('errors')
      @email.validate_each(@mock, "email", "example@example.org")
      @email.validate_each(@mock, "email", "example@@example.org")
      @email.validate_each(@mock, "email", "l0~gin@sub.examp-le.org")
    end

    it "should add message to errors when invalid email address" do
      @mock.errors[].should_receive('<<')
      @email.validate_each(@mock, "email", "notvalid")
      @email.validate_each(@mock, "email", "x@exa$mple.org")
    end
  end
  
  describe 'NameValidator' do
    before :each do
      @name = @validators::NameValidator.new({:attributes => {}})
    end
      
    it "shouldn't add message to errors when valid name" do
      @mock.should_not_receive('errors')
      [
        'Ivan Stana', 'Ivan R. Stana', 'Ivan Ronon Stana',
        'Jean Claude Van Damme', 'Jean-Pierre Cassel',
        'Tatyana Sukhotina-Tolstaya',
        'John R. R. Tolkien', 'I S'
      ].each {
        |name| @name.validate_each(@mock, "name", name)
      }
    end

    it "should add message to errors when invalid name" do
      @mock.errors[].should_receive('<<')
      [
        'J. R. R. Tolkien', 'J.R.R. Tolkien', 'Tolkien', ''
      ].each {
        |name| @name.validate_each(@mock, "name", name)
      }
    end
  end 
    
  describe 'TelephoneValidator' do
    before :each do
      @telephone = @validators::TelephoneValidator.new({:attributes => {}})
    end
      
    it "shouldn't add message to errors when valid telephone" do
      @mock.should_not_receive('errors')
      @telephone.validate_each(@mock, "telephone", '+421123456789')
    end
    
    it "should add message to errors when invalid telephone" do
      @mock.errors[].should_receive('<<')
      @telephone.validate_each(@mock, "telephone", '123')
    end
  end
  
end

