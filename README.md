# ParanoidStarlight

This piece of gem contains some custom validators and converters for ActiveModel.

It have validations for email and name (European style).
And validation and converter (to international format) of telephone number. (CZ/SK format)


## Installation

Add this line to your application's Gemfile:

    gem 'paranoid_starlight'

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

or put this into /config/initializers/paranoid.rb

    ActiveRecord::Base.send(:include, ParanoidStarlight::Validations)
    ActiveRecord::Base.send(:include, ParanoidStarlight::Converters)

Now you have them available globally for models

    class Person < ActiveRecord::Base
      attr_accessible :name, :telephone, :email
      validates_email_format_of :email
      validates_name_format_of :name
      validates_telephone_format_of :telephone
      # or validates :email, :email => true

      before_save :convert_telephone_number(:telephone)
    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
