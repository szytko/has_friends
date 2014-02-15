class RelationType < ActiveRecord::Base
  validates :name, :presence => true
  
  after_destroy :destroy_all_friendship_relations
  
  private
    def destroy_all_friendship_relations
      FriendshipRelationType.delete_all relation_id: self.id
    end
end