# -*- coding: UTF-8 -*-

# This gem is pack of methods to convert or validate
# different formats of strings and texts in model,
# like telephone numbers (CZ/SK format),
# email, or (european) names (currently).
# Or to clean string of too much whitespaces.
#
# It provides *convert* methods for attributes of model
# (getter and setter method in object is enough).
# They are used in save hooks.
#
# There are also *validator* methods for ActiveModel
# and hook for automatic ActiveRecord integration.
# Just type: (require 'paranoid_starlight/active_record')
#

require "./paranoid_starlight/version"
require 'active_model'
require 'twitter_cldr'
require 'fast_gettext'

module ParanoidStarlight
  [
    'converters', 'validators',
    'attributes/converters', 'attributes/validations'].each do |req|
    require_relative File.join('.', 'paranoid_starlight', req + '.rb')
  end
end 
