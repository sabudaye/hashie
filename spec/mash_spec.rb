require "spec_helper"

describe Hashie::Mash do
  before(:each) do
    @mash = Hashie::Mash.new
  end

  it "hello" do
    @mash.hello eq(nil)
  end

end