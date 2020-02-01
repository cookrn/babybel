module Babybel
  module Minibel
    class QuotedSymbol < Symbol
      def unquote; self; end
    end
  end
end
