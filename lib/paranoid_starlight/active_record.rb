# -*- coding: UTF-8 -*-

require_relative "../paranoid_starlight.rb"

require 'active_record'
::ActiveRecord::Base.send(:include, ParanoidStarlight::Validations)
::ActiveRecord::Base.send(:include, ParanoidStarlight::Converters)

