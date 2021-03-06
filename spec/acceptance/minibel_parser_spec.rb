require "spec_helper"

RSpec.describe "Minibel Parser" do
  let(:parser) { Babybel::Minibel::Parser.new }
  let(:minibel_source) { Babybel::Minibel.minibel_source }

  it "parses a subset of bel with which write an interpreter in bel" do
    parsed = false
    result = nil

    begin
      result = parser.parse(minibel_source)
      parsed = true
    rescue Parslet::ParseFailed => error
      puts error.parse_failure_cause.ascii_tree
      binding.pry
    end

    # binding.pry
    expect(parsed).to be(true)
    expect(result).not_to be_empty
  end
end
