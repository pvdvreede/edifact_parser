# -*- coding: UTF-8 -*-

require 'simplecov'
SimpleCov.minimum_coverage 90
SimpleCov.start do
  root File.expand_path('../../', __FILE__)
  add_filter '/spec/'
end

require 'parslet/rig/rspec'
require 'edifact_parser'
