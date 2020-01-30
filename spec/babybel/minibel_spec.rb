require "spec_helper"

RSpec.describe Babybel::Minibel do
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

  context "pairs" do
    it "parses one with symbols" do
      result = nil
      expect { result = subject.parse("((a.b))") }.not_to raise_error
      expect(result.first[:exp].first[:pair][:left].first[:symbol]).to eq("a")
      expect(result.first[:exp].first[:pair][:right][:symbol]).to eq("b")
    end

    it "parses one with symbols and spaces" do
      result = nil
      expect { result = subject.parse(" ( ( a . b ) ) ") }.not_to raise_error
      expect(result.first[:exp].first[:pair][:left].first[:symbol]).to eq("a")
      expect(result.first[:exp].first[:pair][:right][:symbol]).to eq("b")
    end

    it "parses one with symbol and nested pair" do
      result = nil
      expect { result = subject.parse("((a . (b . c)))") }.not_to raise_error
      expect(result.first[:exp].first[:pair][:left].first[:symbol]).to eq("a")

      right_pair = result.first[:exp].first[:pair][:right][:pair]
      expect(right_pair[:left].first[:symbol]).to eq("b")
      expect(right_pair[:right][:symbol]).to eq("c")
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

  context "backquote" do
    it "parses one" do
      result = nil
      expect { result = subject.parse("`(q)") }.not_to raise_error
      expect(result.first[:backquoted]).not_to be_nil
      expect(result.first[:exp].first[:symbol]).to eq("q")
    end

    it "parses one pair" do
      result = nil
      expect { result = subject.parse("`(a . b)") }.not_to raise_error
      expect(result.first[:backquoted]).not_to be_nil
      expect(result.first[:pair][:left].first[:symbol]).to eq("a")
      expect(result.first[:pair][:right][:symbol]).to eq("b")
    end
  end

  context "unquote" do
    it "parses one" do
      result = nil
      expect { result = subject.parse("`(,q)") }.not_to raise_error
      expect(result.first[:backquoted]).not_to be_nil
      expect(result.first[:exp].first[:unquoted]).not_to be_nil
      expect(result.first[:exp].first[:symbol]).to eq("q")
    end

    it "parses one pair with left unquoted" do
      result = nil
      expect { result = subject.parse("`(,a . b)") }.not_to raise_error
      expect(result.first[:backquoted]).not_to be_nil
      expect(result.first[:pair][:left].first[:unquoted]).not_to be_nil
      expect(result.first[:pair][:left].first[:symbol]).to eq("a")
      expect(result.first[:pair][:right][:symbol]).to eq("b")
    end

    it "parses one pair with multiple left some unquoted" do
      result = nil
      expect { result = subject.parse("`(,a b . c)") }.not_to raise_error
      expect(result.first[:backquoted]).not_to be_nil
      expect(result.first[:pair][:left].first[:unquoted]).not_to be_nil
      expect(result.first[:pair][:left].first[:symbol]).to eq("a")
      expect(result.first[:pair][:left].last[:symbol]).to eq("b")
      expect(result.first[:pair][:right][:symbol]).to eq("c")
    end

    it "parses one pair with right unquoted" do
      result = nil
      expect { result = subject.parse("`(a . ,b)") }.not_to raise_error
      expect(result.first[:backquoted]).not_to be_nil
      expect(result.first[:pair][:left].first[:symbol]).to eq("a")
      expect(result.first[:pair][:right][:unquoted]).not_to be_nil
      expect(result.first[:pair][:right][:symbol]).to eq("b")
    end
  end

  context "splice" do
    it "parses one" do
      result = nil
      expect { result = subject.parse("`(,@q)") }.not_to raise_error
      expect(result.first[:backquoted]).not_to be_nil
      expect(result.first[:exp].first[:spliced]).not_to be_nil
      expect(result.first[:exp].first[:symbol]).to eq("q")
    end

    it "parses one pair with left spliced" do
      result = nil
      expect { result = subject.parse("`(,@a . b)") }.not_to raise_error
      expect(result.first[:backquoted]).not_to be_nil
      expect(result.first[:pair][:left].first[:spliced]).not_to be_nil
      expect(result.first[:pair][:left].first[:symbol]).to eq("a")
      expect(result.first[:pair][:right][:symbol]).to eq("b")
    end

    it "parses one pair with multiple left some spliced" do
      result = nil
      expect { result = subject.parse("`(,@a b . c)") }.not_to raise_error
      expect(result.first[:backquoted]).not_to be_nil
      expect(result.first[:pair][:left].first[:spliced]).not_to be_nil
      expect(result.first[:pair][:left].first[:symbol]).to eq("a")
      expect(result.first[:pair][:left].last[:symbol]).to eq("b")
      expect(result.first[:pair][:right][:symbol]).to eq("c")
    end

    it "parses one pair with right spliced" do
      result = nil
      expect { result = subject.parse("`(a . ,@b)") }.not_to raise_error
      expect(result.first[:backquoted]).not_to be_nil
      expect(result.first[:pair][:left].first[:symbol]).to eq("a")
      expect(result.first[:pair][:right][:spliced]).not_to be_nil
      expect(result.first[:pair][:right][:symbol]).to eq("b")
    end
  end

  context "bracket notation" do
    it "parses empty" do
      result = nil
      expect { result = subject.parse("[]") }.not_to raise_error
      expect(result.first[:bracket_exp]).not_to be_empty
    end

    it "parses example with three symbols" do
      result = nil
      expect { result = subject.parse("[f _ x]") }.not_to raise_error
      expect(result.first[:bracket_exp]).not_to be_empty

      bracket_exp = result.first[:bracket_exp][:exp]
      expect(bracket_exp[0][:symbol]).to eq("f")
      expect(bracket_exp[1][:symbol]).to eq("_")
      expect(bracket_exp[2][:symbol]).to eq("x")
    end

    it "parses example with nested expression" do
      result = nil
      expect { result = subject.parse("[id _ (car args)]") }.not_to raise_error
      expect(result.first[:bracket_exp]).not_to be_empty

      bracket_exp = result.first[:bracket_exp][:exp]
      expect(bracket_exp[0][:symbol]).to eq("id")
      expect(bracket_exp[1][:symbol]).to eq("_")

      final_bracket_exp = bracket_exp[2][:exp]
      expect(final_bracket_exp.first[:symbol]).to eq("car")
      expect(final_bracket_exp.last[:symbol]).to eq("args")
    end
  end
end
