%w(
  has_friends
  friendship
  exceptions
).each {|req| require File.dirname(__FILE__) + "/lib/#{req}"}

ActiveRecord::Base.send(:include, SimplesIdeias::Friends)
