module Babybel
  module Minibel
    class Interpreter
      def initialize
        @environment = Environment.new
        @parser = Parser.new
        @transformer = Transformer.new
      end

      def evaluate(minibel_src)
        parsed = @parser.parse(minibel_src)
        transformed = @transformer.apply(parsed)

        transformed.compact.map do |expression|
          evaluate_expression(expression.compact)
        end
      end

      private

      def evaluate_expression(expression)
        case expression
        when Array
          if expression.none?
            expression
          else
            fn_symbol = expression[0]

            if fn_symbol.is_a?(Symbol)
              fn = evaluate_expression(fn_symbol)

              if fn.respond_to?(:call)
                fn.call(*expression[1..-1].map { |e| evaluate_expression(e) })
              else
                expression.map { |e| evaluate_expression(e) }
              end
            else
              expression.map { |e| evaluate_expression(e) }
            end
          end
        when Symbol
          @environment.lookup!(expression)
        when String
          expression
        when Quoted
          expression.unquote
        else
          raise 'Unknown expression type'
        end
      end
    end
  end
end
