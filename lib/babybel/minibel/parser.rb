require "parslet"

module Babybel
  module Minibel
    class Parser < Parslet::Parser
      root :multi_expression
      rule(:multi_expression) { (comment | expression | space).repeat }

      rule(:newline) { str("\n") >> str("\r").maybe }
      rule(:comment) do
        str(";") >> (newline.absent? >> any).repeat.as(:comment) >> newline.maybe
      end

      rule(:expression) do
        space? >> str("(") >> space? >> body >> str(")") >> space?
      end
      
      rule(:inner_body) do
        expression | symbol | string
      end

      rule(:body) do
        (quote? >> inner_body).repeat.as(:exp)
      end
      
      rule(:space) { match('\s').repeat(1) }
      rule(:space?) { space.maybe }
      
      rule(:symbol) do
        (match("[a-zA-Z=*+_]") >> match("[a-zA-Z=*_0-9]").repeat).as(:symbol) >> space?
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
end
