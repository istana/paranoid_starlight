# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paranoid_starlight/version'

Gem::Specification.new do |gem|
  gem.name          = "paranoid_starlight"
  gem.version       = ParanoidStarlight::VERSION
  gem.author       = 'Ivan Stana'
  gem.email         = 'stiipa@centrum.sk'
  gem.summary       = "Pack of custom validations and converters for ActiveModel. Also in standalone version."
  gem.description   = <<-EOF
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
  EOF
  
  gem.homepage      = "http://github.com/istana/paranoid_starlight"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency("activemodel", ["~> 3.2"])
  gem.add_dependency("twitter_cldr", ["~> 2.0"])
  gem.add_dependency("fast_gettext", ["~> 0.6"])
  #gem.add_dependency("activerecord", [">= 3.1"])
  gem.add_development_dependency("rspec")
  gem.required_ruby_version = '>= 1.9.2'
end
