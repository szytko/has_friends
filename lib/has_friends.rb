require 'has_friends/has_friends'
require 'has_friends/exceptions'
require 'has_friends/friendship'
require 'has_friends/friendship_message'
require 'has_friends/relation_type'
require 'has_friends/friendship_relation_type'

ActiveRecord::Base.send(:include, Has::Friends)