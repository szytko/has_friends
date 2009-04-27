require "#{File.dirname(__FILE__)}/spec_helper"

describe FriendshipMessage do
  it "should require a body" do
    @message = FriendshipMessage.new

    @message.should_not be_valid
    @message.errors[:body].should == "can't be blank"
  end
end
