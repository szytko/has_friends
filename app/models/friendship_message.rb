class FriendshipMessage < ActiveRecord::Base
  validates :body, presence: true
end