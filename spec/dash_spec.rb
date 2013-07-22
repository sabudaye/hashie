require "spec_helper"

class DashTest < Hashie::Dash
  property :first_name, :required => true
  property :email
  property :race, :default => "russian"
end

class DashTest2 < Hashie::Dash
  property :test, :default => "test"
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


  it 'errors out when attempting to set a required property to nil' do
    expect{subject.first_name = nil}.to raise_error(ArgumentError)
    expect(subject.first_name).to eq('Bob')
  end

  it "should raise no method error when initialize an nonexisten property" do
    expect{subject.last_name = "Marley"}.to raise_error(NoMethodError)
  end

  it "should return default value" do
    expect(subject.race).to eq("russian")
  end

  it "should respond value when call method using []" do
    expect(subject[:first_name]).to eq('Bob')
  end

  it "should raise error when calling not existing key" do
    expect{subject[:nonexisten]}.to raise_error(NoMethodError)
  end

  it "should work with calling []=" do
    subject[:email] = "bob3@mail.org"
    expect(subject[:email]).to eq("bob3@mail.org")
  end

  it "should raise error when calling not existing key" do
    expect{subject[:test]}.to raise_error(NoMethodError)
  end

end