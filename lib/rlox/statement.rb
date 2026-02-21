# frozen_string_literal: true
# typed: true

module Rlox
  # @abstract
  class Statement
    def accept(visitor)
      raise NotImplementedError, "Subclass must implement accept"
    end
  end
end
