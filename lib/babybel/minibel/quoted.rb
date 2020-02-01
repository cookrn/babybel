module Babybel
  module Minibel
    class Quoted
      def initialize(value)
        @value = value
      end

      def unquote; @value; end
    end
  end
end
