require "spec_helper"

class DashTest < Hashie::Dash
  property :first_name, :required => true
  property :email
end

describe DashTest do
  subject { DashTest.new(:first_name => 'Bob', :email => 'bob@mail.com') }

  it "should return an existing property using []=" do
    expect(subject[:first_name]).to eq('Bob')
    expect(subject[:email]).to eq('bob@mail.com')
  end

  # it 'should works method call for an existing property' do
  #   expect(subject.first_name).to eq('Bob')
  # end
end