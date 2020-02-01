require "parslet"

module Babybel
  module Minibel
    class Transformer < Parslet::Transform
      rule(symbol: simple(:symbol)) { symbol.to_sym }
      rule(quoted: "'", symbol: simple(:symbol)) { Quoted.new(symbol.to_sym) }

      rule(string: simple(:string)) { string.to_s }
      rule(quoted: "'", string: simple(:string)) { Quoted.new(string.to_s) }

      rule(exp: subtree(:_)) { _ }
      rule(quoted: "'", exp: subtree(:_)) { Quoted.new(_) }

      rule(comment: simple(:_)) { nil }
    end
  end
end
