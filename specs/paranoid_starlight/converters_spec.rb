require_relative '../spec_helper.rb'

describe ParanoidStarlight::Converters do
  before :all do
    @p = ParanoidStarlight::Converters
  end

  describe 'convert_telephone' do
  
    it 'accepts all objects, which have to_s method' do
      ['421123456789',
        421123456789,
       :"421123456789"].each do |num|
        @p.convert_telephone(num).should == '+421123456789'
      end
    end
    
    it 'removes non-numeric characters' do
      @p.convert_telephone(' +421 123 / 456789A').should == '+421123456789'
    end
    
    it 'tests valid formats' do
      ['+421 123 456 789',
       '00421 123 456 789',
       '123 456 789',
       '0123 456 789'].each { |num|
         @p.convert_telephone(num).should == '+421123456789'
      }
      @p.convert_telephone('043/5867890').should == '+421435867890'
    end
    
    it 'tests some of invalid formats' do
      ['043/586789',
       '123',
       # 10 digits
       '4211234567890'
      ].each { |num|
        expect {@p.convert_telephone(num)}.to raise_error('Number is invalid')
      }
    end
    
    it 'tests with custom country code prefix' do
      @p.convert_telephone('+421 123 456 789', 410).should == '+421123456789'
      @p.convert_telephone('123 456 789', 410).should == '+410123456789'
      @p.convert_telephone('0123 456 789', 410).should == '+410123456789'
    end
    
    it 'to_i returns number as integer' do
      @p.convert_telephone('+421 123 456 789').to_i.should == 421123456789
    end
    
  end
  
  describe 'telephone_will_convert?' do
    subject {@p.telephone_will_convert?(telephone)}
    
    context 'valid number' do
      let(:telephone) {'+421 123 456 789'}
      it {should be_true}
    end
    
    context 'inconvertible (not invalid by notation!) number' do
      let(:telephone) {'123'}
      it {should be_false}
    end
  end
  
  describe 'one_liner' do
    it 'converts succeeding whitespace(s) to space' do
      @p.one_liner(
        "  Some  \ttext. \t\n\n\n Hello\t\t\nworld."
      ).should == 'Some text. Hello world.'
    end
  end

end

