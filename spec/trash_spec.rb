require "spec_helper"

class TrashTest < Hashie::Trash
  property :first_name, :from => :firstName
end

describe TrashTest do
  subject { TrashTest.new(:first_name => 'Bob') }

  it "AAA" do
    a = TrashTest.new(:firstName => 'Alex')
    a.first_name.should eq('Alex')
    a.firstName eq('Alex')
  end

end