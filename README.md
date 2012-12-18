# ParanoidStarlight

This piece of gem contains some custom validators and converters for ActiveModel.

It has validations for email and name (European style).
And validation and converter (to international format) of telephone number. (CZ/SK format)
Few converters for texts and strings. Specs included.

## Installation

Add this line to your application's Gemfile:

    gem 'paranoid_starlight'

If you want to have methods available for ActiveRecord models, use:
    
    gem 'paranoid_starlight', :require => 'paranoid_starlight/active_record'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paranoid_starlight

## Usage

    class MyModel
      include ActiveModel::Validations
      include ParanoidStarlight::Validations
      
      attr_accessor :email
      validates_email_format_of :email
    end

    model = MyModel.new
    model.email = 'example@example.org'
    model.valid?


If you required active_record hook, you can use:

    class Person < ActiveRecord::Base
      attr_accessible :name, :telephone, :mobile, :email
      attr_accessible :address, :zip

      validates_email_format_of :email
      validates_name_format_of :name
      # few different valid formats are allowed
      validates_telephone_format_of :telephone, :mobile
      # or validates :email, :email => true

      before_save :convert_fields
      before_validation :process_fields

      def convert_fields
        # convert to international form
        convert_telephone_number(:telephone)
        convert_telephone_number(:mobile)
        # or convert_telephone_number [:telephone, :mobile]
        # do other things
      end

      def process_fields
        clean_text([:address, :zip])
      end
    end

Currently there are these possibilities:
- validates_email_format_of
- validates_name_format_of
- validates_telephone_number_of

- clean_text
- clean_whitespaces
- convert_telephone_number

It is easy to create own converter, just do:

    class Kiddie
      include ::ParanoidStarlight::Converters
      attr_accessor :name
      
      def l33t
        basic_converter(self, :name) do |text|
          text.gsub('e', '3')
        end
      end
    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Author
Created by Ivan Stana  
License: MIT

I encourage to write me something
