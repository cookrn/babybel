module Babybel
  module Minibel
    class Environment
      def lookup!(symbol)
        if public_methods.include?(symbol)
          public_method(symbol)
        elsif instance_variables.include?(:"@#{symbol}")
          instance_variable_get(:"@#{symbol}")
        else
          raise NameError, "Undefined: #{symbol}"
        end
      end

      def _rb(fn, *args)
        public_send(fn, *args)
      end
    end
  end
end
