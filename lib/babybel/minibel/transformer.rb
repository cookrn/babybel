require "parslet"

module Babybel
  module Minibel
    class Transformer < Parslet::Transform
      rule(string: simple(:s)) { s.to_s }
      rule(quoted: "'", symbol: simple(:s)) { s.to_sym }
    end
  end
end
