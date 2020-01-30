require "babybel/version"

module Babybel
  class Error < StandardError; end

  def self.minibel_source
    File.read(File.join(File.dirname(__FILE__), 'babybel', 'minibel.bel'))
  end
end

require "babybel/minibel"
