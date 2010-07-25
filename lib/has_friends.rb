require 'has_friends/engine'
require 'has_friends/has_friends'
require 'has_friends/exceptions'

ActiveRecord::Base.send(:include, Has::Friends)