$:.unshift(File.join(File.dirname(__FILE__), "lib"))

require "rubygems"
require "bundler"
Bundler.setup

require 'rails'
require 'ruby-debug'
require 'active_record'
require "active_support"

require "filtered_relation"