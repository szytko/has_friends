require "#{File.dirname(__FILE__)}/spec_helper"

describe FriendshipRelationType do
  describe "structure" do
    it "should belong_to :friendship" do
      @friendship = Friendship.new
      @friendship_relation = FriendshipRelationType.new :friendship => @friendship
      @friendship_relation.friendship.should == @friendship
    end

    it "should belong_to :relation" do
      @relation = RelationType.new
      @friendship_relation = FriendshipRelationType.new :relation => @relation
      @friendship_relation.relation.should == @relation
    end
  end
end
