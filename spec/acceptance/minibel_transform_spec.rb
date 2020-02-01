require "spec_helper"

RSpec.describe "Minibel Transformer" do
  let(:transformer) { Babybel::Minibel::Transformer.new }
  let(:parser) { Babybel::Minibel::Parser.new }
  let(:minibel_source) { Babybel::Minibel.minibel_source }

  it "processes the minibel parser output" do
    transformed = false
    result = nil

    begin
      parse_result = parser.parse(minibel_source)
      result = transformer.apply(parse_result)
      transformed = true
    rescue => error
      binding.pry
    end

    # binding.pry
    expect(transformed).to be(true)
    expect(result).not_to be_empty
  end
end
