require "#{File.dirname(__FILE__)}/spec_helper"

describe Friendship do
  fixtures :all
  
  describe "structure" do
    before(:each) do
      @friendship = Friendship.new
    end

    it "should belong to user" do
      @friendship.user = @vader
      @friendship.user.should == @vader
    end

    it "should_belong to friend" do
      @friendship.friend = @luke
      @friendship.friend.should == @luke
    end

    it "should belong to message" do
      @message = FriendshipMessage.new :body => "Luke, I'm your father!"
      @friendship.message = @vader_message_for_luke
      @friendship.message.should == @vader_message_for_luke
    end

    it "should has many relations" do
      @friendship.relations << @friend
      @friendship.relations << @coworker

      @friendship.relations.should == [@friend, @coworker]
    end
  end

  it "should be pending status" do
    @friendship = Friendship.new(:status => 'pending')
    @friendship.should be_pending
  end

  it "should be accepted status" do
    @friendship = Friendship.new(:status => 'accepted')
    @friendship.should be_accepted
  end

  it "should be requested status" do
    @friendship = Friendship.new(:status => 'requested')
    @friendship.should be_requested
  end

  describe "on accept pending friendship" do
    before(:each) do
      @friendship = Friendship.create(:user => @vader, :friend => @luke, :status => Friendship::FRIENDSHIP_PENDING)
    end

    it "should be ok" do
      @friendship.accept!
      @friendship.status.should == Friendship::FRIENDSHIP_ACCEPTED
    end

    it "should be ok and add new relations" do
      @friendship.accept!([:met, :coworker])
      @friendship.status.should == Friendship::FRIENDSHIP_ACCEPTED
      @friendship.relations.size == 2
      @friendship.relations.should == [@met, @coworker]
    end

    describe "with relations" do
      before(:each) do
        [@friend, @met].each do |r|
          @friendship.relations << r
        end
        @friendship.save
      end

      it "should be ok and no change current relations" do
        @friendship.accept!
        @friendship.reload

        @friendship.status.should == Friendship::FRIENDSHIP_ACCEPTED
        @friendship.relations.size.should == 2
        @friendship.relations.should == [@friend, @met]
      end

      it "should be ok and change relations" do
        @friendship.accept!([:met, :coworker])
        @friendship.reload

        @friendship.status.should == Friendship::FRIENDSHIP_ACCEPTED
        @friendship.relations.size.should == 2
        @friendship.relations.should == [@met, @coworker]
      end

      it "should be ok and clear current relations" do
        @friendship.accept!([])
        @friendship.reload

        @friendship.status.should == Friendship::FRIENDSHIP_ACCEPTED
        @friendship.relations.size.should == 0
        @friendship.relations.should == []
      end
    end

  end
end
