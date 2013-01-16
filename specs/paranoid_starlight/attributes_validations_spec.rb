require_relative '../spec_helper.rb'

class WithValidations
  include ActiveModel::Validations
  include ParanoidStarlight::Attributes::Validations
end

class TestEmail < WithValidations
  attr_accessor :email_field
  validates_email_format_of :email_field
end

class TestName < WithValidations
  attr_accessor :name_field
  validates_name_format_of :name_field
end

class TestName < WithValidations
  attr_accessor :name_field
  validates_name_format_of :name_field
end

class TestTelephone < WithValidations
  attr_accessor :telephone
  
  # will be deprecated or reqorked
  # validates_telephone_number_of :telephone
  validates_telephone_number_convertibility_of :telephone
end

describe ParanoidStarlight::Attributes::Validations do 
  # I won't test multiple attributes as argument
  # it works, because it is copied from rails
      
  describe 'validates_email_format_of' do
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

  describe 'validates_name_format_of' do
    subject { TestName.new() }
    before { subject.name_field = name }

    context 'is valid' do
      let(:name) {'Geralt of Rivia'}
      it { should be_valid }
    end

    context 'is invalid' do
      let(:name) {'Shakespeare'}
      it { should be_invalid }
    end
  end

  describe 'validates_telephone_number_of' do
    subject { TestTelephone.new() }
    before { subject.telephone = telephone }

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