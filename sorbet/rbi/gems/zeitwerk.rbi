# typed: true

module Zeitwerk
  class Loader
    sig { returns(Zeitwerk::Loader) }
    def self.for_gem; end

    sig { void }
    def setup; end
  end
end
