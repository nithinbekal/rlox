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

require_relative "expr/assign"
require_relative "expr/binary"
require_relative "expr/grouping"
require_relative "expr/literal"
require_relative "expr/unary"
require_relative "expr/variable"
