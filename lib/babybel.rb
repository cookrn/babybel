require "babybel/version"

module Babybel
  class Error < StandardError; end

  def self.bel_source
    @_bel_source ||= File.read(File.join(File.dirname(__FILE__), 'babybel', 'bel.bel'))
  end
end

require "babybel/parser"
require "babybel/minibel"
