# ParanoidStarlight

This gem is pack of methods to convert or validate
different formats of strings and texts in model,
like telephone numbers (CZ/SK format),
email, or (european) names (currently).
Or to clean string of too much whitespaces.

It provides *convert* methods for attributes of model
(getter and setter method in object is enough).
They are used in save hooks.

There are also *validator* methods for ActiveModel
nd hook for automatic ActiveRecord integration.
Just type: (`require 'paranoid_starlight/active_record'`)

Specs included.

## Installation

Add this line to your application's Gemfile:

    gem 'paranoid_starlight'

If you want to have methods available for `ActiveRecord` models, use:
    
    gem 'paranoid_starlight', :require => 'paranoid_starlight/active_record'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paranoid_starlight

## Usage

    class MyModel
      include ActiveModel::Validations
      include ParanoidStarlight::Attributes::Validations
      
      attr_accessor :email
      validates_email_format_of :email
    end

    model = MyModel.new
    model.email = 'example@example.org'
    model.valid?


If you required active_record hook, you can use:

    require 'paranoid_starlight/active_record'

    class Person < ActiveRecord::Base
      attr_accessible :name, :telephone, :mobile, :email
      attr_accessible :address, :zip

      validates_email_format_of :email
      validates_name_format_of :name
      # few different valid formats are allowed
      validates_telephone_number_convertibility_of :telephone, :mobile
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
        process_string([:address, :zip])
      end
    end

Currently there are these possibilities:

*Validations for ActiveModel*

- validates_email_format_of
- validates_name_format_of
- validates_telephone_number_convertibility_of

*Converters for attributes* (getter and setter methods in object are enough)

- process_string (substitutes one or more whitespaces with space)
- convert_telephone_number

It is easy to create own converter, just do:

    class Kiddie
      include ::ParanoidStarlight::Attributes::Converters
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

## TODO

Separate email and name validators to own functions, to be independent from ActiveModel validators.

## Author
Programmed in 2012  
by Ivan Stana  
License: MIT  

