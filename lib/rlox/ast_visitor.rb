# frozen_string_literal: true
# typed: true

module Rlox
  # @abstract
  #: [ReturnType < Object]
  class AstVisitor
    # @abstract
    #: (Binary binary) -> ReturnType
    def visit_binary(binary)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Grouping grouping) -> ReturnType
    def visit_grouping(grouping)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Literal literal) -> ReturnType
    def visit_literal(literal)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Unary unary) -> ReturnType
    def visit_unary(unary)
      raise NotImplementedError, "Subclasses must implement this method"
    end
  end
end
