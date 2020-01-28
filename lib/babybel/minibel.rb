require "parslet"

module Babybel
  class Minibel < Parslet::Parser
    root :multi_expression
    rule(:multi_expression) { expression.repeat }

    rule(:expression) do
      space? >> str("(") >> space? >> body >> str(")") >> space?
    end
    
    rule(:pair) do
      space? >> str("(") >> space? >> (inner_body.repeat.as(:left) >> str(".") >> \
        space? >> inner_body.as(:right)).as(:pair) >> str(")") >> space?
    end
    
    rule(:inner_body) do
      expression | pair | symbol | string
    end

    rule(:body) do
      (quote? >> inner_body).repeat.as(:exp)
    end
    
    rule(:space) { match('\s').repeat(1) }
    rule(:space?) { space.maybe }
    
    rule(:symbol) do
      (match("[a-zA-Z=*+]") >> match("[a-zA-Z=*_]").repeat).as(:symbol) >> space?
    end

    rule(:quote) { str("'").as(:quoted) }
    rule(:quote?) { quote.maybe }

    rule(:string) do
      str('"') >> (
        str('\\') >> any |
        str('"').absent? >> any 
      ).repeat.as(:string) >> str('"') >> space?
    end
  end
end
