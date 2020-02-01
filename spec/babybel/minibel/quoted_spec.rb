require "spec_helper"

RSpec.describe Babybel::Minibel::Quoted do
  let(:quoted_list) { described_class.new([]) }
  let(:quoted_symbol) { described_class.new(:a) }
  let(:quoted_string) { described_class.new('a') }

  it "unquotes an array" do
    expect(quoted_list.unquote).to eq([])
  end

  it "unquotes a symbol" do
    expect(quoted_symbol.unquote).to eq(:a)
  end

  it "unquotes a string" do
    expect(quoted_string.unquote).to eq('a')
  end
end
