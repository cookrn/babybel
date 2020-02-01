require "spec_helper"

RSpec.describe Babybel::Minibel::Transformer do
  let(:transformer) { Babybel::Minibel::Transformer.new }
  let(:parser) { Babybel::Minibel::Parser.new }
  let(:parsed) { parser.parse(expression) }
  let(:transformed) { transformer.apply(parsed) }

  context "when encountering a comment" do
    let(:expression) { '; comment' }

    it "returns empty" do
      expect { transformed }.not_to raise_error
      expect(transformed.first).to eq(nil)
    end
  end

  context "when encountering an empty expression" do
    let(:expression) { '()' }

    it "returns a list" do
      expect { transformed }.not_to raise_error
      expect(transformed.first).to be_empty
    end
  end

  context "when encountering an expression containing an expression" do
    let(:expression) { '(())' }

    it "returns a nested list" do
      expect { transformed }.not_to raise_error
      expect(transformed.first).not_to be_empty
      expect(transformed.first.first).to eq([])
    end
  end

  context "when encountering an expression with a symbol" do
    let(:expression) { '(a)' }

    it "returns a list with the symbol" do
      expect { transformed }.not_to raise_error
      expect(transformed.first).not_to be_empty
      expect(transformed.first.first).to eq(:a)
    end
  end

  context "when encountering an expression with a string" do
    let(:expression) { '("string")' }

    it "returns a list with the symbol" do
      expect { transformed }.not_to raise_error
      expect(transformed.first).not_to be_empty
      expect(transformed.first.first).to eq("string")
    end
  end

  context "when encountering a quoted expression" do
    let(:expression) { "('(a))" }

    it "returns a quoted list with the symbol" do
      expect { transformed }.not_to raise_error
      expect(transformed.first).not_to be_empty
      expect(transformed.first.first).to be_a(Babybel::Minibel::Quoted)
      expect(transformed.first.first.unquote).to eq([:a])
    end
  end

  context "when encountering a quoted symbol" do
    let(:expression) { "('a)" }

    it "returns a quoted symbol" do
      expect { transformed }.not_to raise_error
      expect(transformed.first).not_to be_empty
      expect(transformed.first.first).to be_a(Babybel::Minibel::Quoted)
      expect(transformed.first.first.unquote).to eq(:a)
    end
  end

  context "when encountering a quoted string" do
    let(:expression) { "('\"a\")" }

    it "returns a quoted string" do
      expect { transformed }.not_to raise_error
      expect(transformed.first).not_to be_empty
      expect(transformed.first.first).to be_a(Babybel::Minibel::Quoted)
      expect(transformed.first.first.unquote).to eq('a')
    end
  end
end
