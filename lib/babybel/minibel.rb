require "parslet"

module Babybel
  class Minibel < Parslet::Parser
    root :multi_expression
    rule(:multi_expression) { (expression | pair).repeat }

    rule(:expression) do
      space? >> backquote? >> str("(") >> space? >> body >> str(")") >> space?
    end
    
    rule(:pair) do
      space? >> backquote? >> str("(") >> space? >> ((unquote? >> inner_body).repeat.as(:left) >> \
        str(".") >> space? >> (unquote? >> inner_body).as(:right)).as(:pair) >> str(")") >> space?
    end
    
    rule(:inner_body) do
      expression | pair | symbol | string
    end

    rule(:body) do
      (quote? >> unquote? >> inner_body).repeat.as(:exp)
    end
    
    rule(:space) { match('\s').repeat(1) }
    rule(:space?) { space.maybe }
    
    rule(:symbol) do
      (match("[a-zA-Z=*+]") >> match("[a-zA-Z=*_]").repeat).as(:symbol) >> space?
    end

    rule(:quote) { str("'").as(:quoted) }
    rule(:quote?) { quote.maybe }

    rule(:backquote) { str("`").as(:backquoted) }
    rule(:backquote?) { backquote.maybe }

    rule(:unquote) { str(",").as(:unquoted) >> splice? }
    rule(:unquote?) { unquote.maybe }

    rule(:splice) { str("@").as(:spliced) }
    rule(:splice?) { splice.maybe }

    rule(:string) do
      str('"') >> (
        str('\\') >> any |
        str('"').absent? >> any 
      ).repeat.as(:string) >> str('"') >> space?
    end
  end
end
