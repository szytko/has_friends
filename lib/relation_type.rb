class RelationType < ActiveRecord::Base
  validates_presence_of :name
  
  after_destroy :destroy_all_friendsip_relations
  
  private
    def destroy_all_friendsip_relations
      FriendshipRelationType.delete_all :relation_id => self.id
    end
end