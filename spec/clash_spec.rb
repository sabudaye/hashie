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

  it 'it should be able to set an hash as attribute' do
    @clash.where(:abc => 'def')
    expect(@clash).to eq({:where => {:abc => 'def'}})
  end

  it 'it should be able to set an hash as attribute' do
    @clash.where(:abc => 'def').order(:created_at)
    expect(@clash).to eq({:where => {:abc => 'def'}, :order => :created_at})
  end

  it 'should be able to jump back up to the parent in the chain with #_end!' do
    @clash.foo!.bar('abc').abc('bar')._end!.baz(123)
    expect(@clash).to eq({:foo => {:bar => 'abc', :abc => 'bar'}, :baz => 123})
  end
end