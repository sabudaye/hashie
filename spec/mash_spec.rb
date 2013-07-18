require "spec_helper"

describe Hashie::Mash do
  before(:each) do
    @mash = Hashie::Mash.new
  end

  it "It should equal nil" do
    @mash.name.should == nil
  end

  it "should be able to set hash values through method calls" do
    @mash.name = "Name"
    @mash.name.should == "Name"
  end

  it "It should test for already set values when passed a ? method" do
    @mash.name?.should be_false
    @mash.name = "Name"
    @mash.name?.should be_true
  end

end