class FriendshipRelation < ActiveRecord::Base
  belongs_to :friendship
  belongs_to :relation
end