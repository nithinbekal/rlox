# frozen_string_literal: true
# typed: true

module Rlox
  # @abstract
  class Expr
    def accept(visitor)
      raise NotImplementedError, "Subclasses must implement this method"
    end
  end
end

