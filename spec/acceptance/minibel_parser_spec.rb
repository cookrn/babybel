require "spec_helper"

RSpec.describe "Minibel Parser" do
  let(:parser) { Babybel::Minibel.new }

  let(:bel_source) { Babybel.minibel_source }

  it "parses enough bel to write an interpreter in bel" do
    parsed = false
    result = nil

    begin
      result = parser.parse(bel_source)
      parsed = true
    rescue Parslet::ParseFailed => error
      puts error.parse_failure_cause.ascii_tree
      binding.pry
    end

    # binding.pry
    expect(parsed).to be(true)
  end
end
