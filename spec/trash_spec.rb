require "spec_helper"

class TrashTest < Hashie::Trash
  property :first_name, :from => :firstName
end

describe TrashTest do
  subject { TrashTest.new(:first_name => 'Bob') }

  it "should give access with CamelCase key or underscore key" do
    a = TrashTest.new(:firstName => 'Alex')
    expect(a.first_name).to eq('Alex')
    expect(a.firstName).to eq('Alex')
  end

end