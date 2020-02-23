require "spec_helper"

RSpec.describe "Minibel Interpreter", :focus do
  let(:interpreter) { Babybel::Minibel::Interpreter.new }
  let(:minibel_source) { Babybel::Minibel.minibel_source }

  it "evaluates the minibel transformer output" do
    evaluated = false
    result = nil

    begin
      result = interpreter.evaluate(minibel_source)
      evaluated = true
    rescue => error
      binding.pry
    end

    # binding.pry
    expect(evaluated).to be(true)
    expect(result).to be_nil
  end
end
