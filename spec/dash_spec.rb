require "spec_helper"

class DashTest < Hashie::Dash
  property :first_name, :required => true
  property :email
end

describe DashTest do
  subject { DashTest.new(:first_name => 'Bob', :email => 'bob@mail.com') }

  it "should return an existing property using method call" do
    expect(subject.first_name).to eq('Bob')
    expect(subject.email).to eq('bob@mail.com')
  end

  it "should save values using method call" do
    subject.email = "bob2@mail.net"
    expect(subject.email).to eq('bob2@mail.net')
  end

  it "should raise no method error when initialize an nonexisten property" do
    expect{subject.last_name = "Marley"}.to raise_error(NoMethodError)
  end
end