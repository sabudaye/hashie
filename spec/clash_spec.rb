require "spec_helper"

describe Hashie::Clash do
  before do
    @clash = Hashie::Clash.new
  end
  
  it 'should be able to set an attribute via method_missing' do
    @clash.foo('bar')
    expect(@clash[:foo]).to eq('bar')
  end

  it 'should be able to set an attribute via method_missing' do
    @clash.foo('bar').bar('foo')
    expect(@clash[:bar]).to eq('foo')
  end
end