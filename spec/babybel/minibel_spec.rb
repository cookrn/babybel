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

  # context "characters" do
  #   it "parses one" do
  #     result = nil
  #     expect { result = subject.parse("(\\c)") }.not_to raise_error
  #     expect(result.first[:exp].first[:character]).to eq("\\c")
  #   end

  #   it "parses one with spaces" do
  #     result = nil
  #     expect { result = subject.parse(" ( \\c ) ") }.not_to raise_error
  #     expect(result.first[:exp].first[:character]).to eq("\\c")
  #   end

  #   it "parses one that is complex" do
  #     result = nil
  #     expect { result = subject.parse("(\\bel)") }.not_to raise_error
  #     expect(result.first[:exp].first[:character]).to eq("\\bel")
  #   end

  #   it "parses one that is complex with spaces" do
  #     result = nil
  #     expect { result = subject.parse(" ( \\bel ) ") }.not_to raise_error
  #     expect(result.first[:exp].first[:character]).to eq("\\bel")
  #   end
  # end

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

    # it "parses one with symbol and character" do
    #   result = nil
    #   expect { result = subject.parse("((\\a . b))") }.not_to raise_error
    #   expect(result.first[:exp].first[:pair][:left][:exp].first[:character]).to eq("\\a")
    #   expect(result.first[:exp].first[:pair][:right][:exp].first[:symbol]).to eq("b")
    # end

    it "parses one with symbol and nested pair" do
      result = nil
      expect { result = subject.parse("((a . (b . c)))") }.not_to raise_error
      expect(result.first[:exp].first[:pair][:left].first[:symbol]).to eq("a")

      right_pair = result.first[:exp].first[:pair][:right][:pair]
      expect(right_pair[:left].first[:symbol]).to eq("b")
      expect(right_pair[:right][:symbol]).to eq("c")
    end

    # it "parses one with nested pair and character" do
    #   result = nil
    #   expect { result = subject.parse("(((b . c) . \\a))") }.not_to raise_error

    #   left_pair = result.first[:exp].first[:pair][:left][:exp].first[:pair]
    #   expect(left_pair[:left][:exp].first[:symbol]).to eq("b")
    #   expect(left_pair[:right][:exp].first[:symbol]).to eq("c")

    #   expect(result.first[:exp].first[:pair][:right][:exp].first[:character]).to eq("\\a")
    # end
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

    # it "parses symbol with nested list followed by character" do
    #   result = nil
    #   expect { result = subject.parse("(a (b) \\c)") }.not_to raise_error
    #   expect(result.first[:exp].first[:symbol]).to eq("a")
    #   expect(result.first[:exp][1][:exp].first[:symbol]).to eq("b")
    #   expect(result.first[:exp].last[:character]).to eq("\\c")
    # end
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
end
