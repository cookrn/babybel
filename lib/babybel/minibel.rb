require "babybel/minibel/parser"
require "babybel/minibel/transformer"
require "babybel/minibel/quoted"
require "babybel/minibel/interpreter"
require "babybel/minibel/environment"

module Babybel
  module Minibel
    def self.minibel_source
      @_minibel_source ||= File.read(File.join(File.dirname(__FILE__), 'minibel', 'minibel.bel'))
    end
  end
end
