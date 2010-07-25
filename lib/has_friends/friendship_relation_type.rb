class FriendshipRelationType < ActiveRecord::Base
  belongs_to :friendship
  belongs_to :relation, :class_name => "RelationType"
end