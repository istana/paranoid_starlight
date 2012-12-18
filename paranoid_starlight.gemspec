# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paranoid_starlight/version'

Gem::Specification.new do |gem|
  gem.name          = "paranoid_starlight"
  gem.version       = ParanoidStarlight::VERSION
  gem.author       = 'Ivan Stana'
  gem.email         = 'stiipa@centrum.sk'
  gem.summary       = "Pack of custom validations and converters for ActiveModel. Or standalone."
  gem.description   = <<-EOF
    It has validations for email and name (European style).
    And validation and converter (to international format)
    of telephone number. (CZ/SK format)
    Few converters for texts and strings. Specs included.
  EOF
  
  gem.homepage      = "http://github.com/istana/paranoid_starlight"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency("activemodel", ["~> 3.2"])
  gem.add_dependency("twitter_cldr", ["~> 2.0"])
  gem.add_dependency("fast_gettext", ["~> 0.6"])
  #gem.add_dependency("activerecord", ["~> 3.2"])
  gem.add_development_dependency("rspec")
  gem.required_ruby_version = '>= 1.9.2'
end
