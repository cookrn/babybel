require "spec_helper"

RSpec.describe "Babybel Parser" do
  let(:parser) { Babybel::Parser.new }
  let(:bel_source) { Babybel.bel_source }

  it "parses the full bel source" do
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
    expect(result).not_to be_empty
  end
end
