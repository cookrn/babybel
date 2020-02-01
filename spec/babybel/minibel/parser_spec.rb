require "spec_helper"

RSpec.describe Babybel::Minibel::Parser do
  context "comments" do
    it "parses one" do
      result = nil
      expect { result = subject.parse("; some comment") }.not_to raise_error
      expect(result.first[:comment]).to eq(" some comment")
    end

    it "terminates at the newline" do
      result = nil
      expect { result = subject.parse("; some comment\n(a)") }.not_to raise_error
      expect(result.first[:comment]).to eq(" some comment")
      expect(result.last[:exp].first[:symbol]).to eq("a")
    end
  end

  context "symbols" do
    it "parses one" do
      result = nil
      expect { result = subject.parse("(symbol)") }.not_to raise_error
      expect(result.first[:exp].first[:symbol]).to eq("symbol")
    end

    it "parses one with spaces" do
      result = nil
      expect { result = subject.parse(" ( symbol ) ") }.not_to raise_error
      expect(result.first[:exp].first[:symbol]).to eq("symbol")
    end

    it "allows addition operator symbol" do
      result = nil
      expect { result = subject.parse("(+)") }.not_to raise_error
      expect(result.first[:exp].first[:symbol]).to eq("+")
    end
  end

  context "lists" do
    it "parses empty" do
      result = nil
      expect { result = subject.parse("()") }.not_to raise_error
      expect(result.first[:exp]).to be_empty
    end

    it "parses empty with spaces" do
      result = nil
      expect { result = subject.parse(" ( ) ") }.not_to raise_error
      expect(result.first[:exp]).to be_empty
    end

    it "parses two symbols" do
      result = nil
      expect { result = subject.parse("(a b)") }.not_to raise_error
      expect(result.first[:exp].first[:symbol]).to eq("a")
      expect(result.first[:exp].last[:symbol]).to eq("b")
    end

    it "parses symbol with nested list" do
      result = nil
      expect { result = subject.parse("(a (b))") }.not_to raise_error
      expect(result.first[:exp].first[:symbol]).to eq("a")
      expect(result.first[:exp].last[:exp].first[:symbol]).to eq("b")
    end

    it "parses symbol with nested list and following symbol" do
      result = nil
      expect { result = subject.parse("(a (b) c)") }.not_to raise_error
      expect(result.first[:exp].first[:symbol]).to eq("a")
      expect(result.first[:exp][1][:exp].first[:symbol]).to eq("b")
      expect(result.first[:exp].last[:symbol]).to eq("c")
    end
  end

  context "strings" do
    it "parses one" do
      result = nil
      expect { result = subject.parse('("string")') }.not_to raise_error
      expect(result.first[:exp].first[:string]).to eq("string")
    end
  end

  context "quote" do
    it "parses one" do
      result = nil
      expect { result = subject.parse("('q)") }.not_to raise_error
      expect(result.first[:exp].first[:quoted]).not_to be_nil
      expect(result.first[:exp].first[:symbol]).to eq("q")
    end

    it "parses two" do
      result = nil
      expect { result = subject.parse("('qa 'qb)") }.not_to raise_error
      expect(result.first[:exp].first[:quoted]).not_to be_nil
      expect(result.first[:exp].first[:symbol]).to eq("qa")
      expect(result.first[:exp].last[:quoted]).not_to be_nil
      expect(result.first[:exp].last[:symbol]).to eq("qb")
    end
  end
end
