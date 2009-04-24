class Friendship < ActiveRecord::Base
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
  named_scope :pending, :conditions => {:status => FRIENDSHIP_PENDING}
  named_scope :accepted, :conditions => {:status => FRIENDSHIP_ACCEPTED}
  named_scope :requested, :conditions => {:status => FRIENDSHIP_REQUESTED}
  
  # associations
  belongs_to :user
  belongs_to :friend, :class_name => 'User', :foreign_key => 'friend_id'
  belongs_to :message, :class_name => "FriendshipMessage", :foreign_key => "friendship_message_id"
  
  has_many :friendship_relations, :readonly => true
  has_many :relations, :through => :friendship_relations
  
  # callback
  after_destroy do |f|
    User.decrement_counter(:friends_count, f.user_id)
  end
  
  def pending?
    status == FRIENDSHIP_PENDING
  end
  
  def accepted?
    status == FRIENDSHIP_ACCEPTED
  end
  
  def requested?
    status == FRIENDSHIP_REQUESTED
  end
  
  def accept!(new_relations = nil)
    unless accepted?
      User.increment_counter(:friends_count, user.id)
      update_attribute(:status, FRIENDSHIP_ACCEPTED)
      add_relations(new_relations) unless new_relations.nil?
    end
  end
  
  def add_relations(new_relations = [])
    self.relations.each do |r|
      r.destroy unless new_relations.include?(r.name.to_sym)
    end
    
    new_relations.each do |r|
      relation = Relation.find_or_create_by_name(r.to_s)
      self.relations << relation unless self.relations.include?(relation)
    end
  end
end