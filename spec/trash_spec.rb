require "spec_helper"

class TrashTest < Hashie::Trash
  property :first_name, :from => :firstName
end

describe TrashTest do
  subject { TrashTest.new(:firstName => 'Alex') }

  it "should give access with CamelCase key or underscore key" do
    expect(subject.first_name).to eq('Alex')
    expect(subject.firstName).to eq('Alex')
  end

  it "should save data on property key when using 'from' key" do
    subject.firstName = "Bob"
    expect(subject.first_name).to eq('Bob')
    subject.first_name = "Dima"
    expect(subject.firstName).to eq('Dima')
  end

  it "should work with calling []=" do
    expect(subject[:firstName]).to eq("Dima")
    expect(subject[:first_name]).to eq("Dima")
  end
end