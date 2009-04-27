require "#{File.dirname(__FILE__)}/spec_helper"

describe RelationType do
  it "should require a name" do
    @relation_type = RelationType.new
    @relation_type.should_not be_valid
    @relation_type.errors[:name].should == "can't be blank"
  end
end
