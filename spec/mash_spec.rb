require "spec_helper"

describe Hashie::Mash do
  before do
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

  it "should create new Mash as key" do
    @mash.name = "Name"
    @mash.name!.add = "add"
    @mash.name.add.should == "add"
  end

  it "should return a Hashie::Mash when passed a bang method to a non-existenct key" do
   expect(@mash.abc!.is_a?(Hashie::Mash)).to be_true
  end

  it "should allow for multi-level assignment through bang methods" do
    @mash.author!.name = "Michael Bleigh"
    expect(@mash.author).to eq("name" => "Michael Bleigh")
    @mash.author!.website!.url = "http://www.mbleigh.com/"
    expect(@mash.author.website).to eq("url" => "http://www.mbleigh.com/")
  end
end