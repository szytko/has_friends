class Friendship < ActiveRecord::Base

  # Default serializer
  include ActiveModel::Serializers::JSON

  # Serializable attributes
  def attributes
    {
        id: nil,
        accepted_at: nil,
        friend: nil,
        user: nil,
        status: nil,
        created_at: nil
    }
  end

  include HasRevisions

  # constants
  STATUS_ALREADY_FRIENDS     = 1
  STATUS_ALREADY_REQUESTED   = 2
  STATUS_IS_YOU              = 3
  STATUS_FRIEND_IS_REQUIRED  = 4
  STATUS_FRIENDSHIP_ACCEPTED = 5
  STATUS_REQUESTED           = 6
  
  FRIENDSHIP_ACCEPTED = "accepted"
  FRIENDSHIP_PENDING = "pending"
  FRIENDSHIP_REQUESTED = "requested"
  
  # scopes
  scope :pending, -> {where(status: FRIENDSHIP_PENDING)}
  scope :accepted, -> {where(status: FRIENDSHIP_ACCEPTED)}
  scope :requested, -> {where(status: FRIENDSHIP_REQUESTED)}
  
  # associations
  belongs_to :user

  belongs_to :friend,
             class_name: 'User',
             foreign_key: 'friend_id'

  belongs_to :message,
             class_name: "FriendshipMessage",
             foreign_key: "friendship_message_id",
             dependent: :destroy
  
  has_many :friendship_relations,
           readonly: true,
           class_name: "FriendshipRelationType",
           dependent: :destroy

  has_many :relations,
           through: :friendship_relations,
           class_name: "RelationType",
           source: :relation
  
  # callback
  after_destroy do |f|
    User.decrement_counter(:friends_count, f.user_id) if f.status == FRIENDSHIP_ACCEPTED
  end

  # Sends notifications to devices
  after_create {
    update_revision(self.user, 'create')
    update_revision(self.friend, 'create')
  }
  after_update {
    update_revision(self.user, 'update')
    update_revision(self.friend, 'update')
  }
  after_destroy {
    update_revision(self.user, 'delete')
    update_revision(self.friend, 'delete')
  }
  
  def pending?
    status == FRIENDSHIP_PENDING
  end
  
  def accepted?
    status == FRIENDSHIP_ACCEPTED
  end
  
  def requested?
    status == FRIENDSHIP_REQUESTED
  end

  def accept!(new_relation_names = nil)
    unless accepted?
      self.transaction do
        User.increment_counter(:friends_count, user_id)
        update_attributes({status: FRIENDSHIP_ACCEPTED, accepted_at: Time.now})
        add_relations(new_relation_names) unless new_relation_names.nil?
      end
    end
  end
  
  def add_relations(new_relation_names = [])
    self.transaction do
      actual_relation_names = self.relation_names
      self.friendship_relations.each do |fr|
        fr.destroy unless actual_relation_names.include?(fr.relation.name.to_sym)
      end

      new_relation_names.each do |nr|
        relation = RelationType.find_or_create_by_name(nr.to_s)
        self.relations << relation unless relations.include?(relation)
      end
    end
  end
  
  def relation_names
    relations.order(:name).collect{|r| r.name}
  end
end

# Friendship Errors
class Friendship::ExistsError < StandardError

end

class Friendship::NotFoundError < StandardError

end

class Friendship::InvitationError < StandardError

end

class Friendship::AcceptError < StandardError

end

class Friendship::DenyError < StandardError

end

class Friendship::RemoveError < StandardError

end