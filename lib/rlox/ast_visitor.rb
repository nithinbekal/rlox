# frozen_string_literal: true
# typed: true

module Rlox
  # @interface
  module AstVisitor
    include Kernel

    # @abstract
    #: (Binary binary) -> Object
    def visit_binary(binary)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Grouping grouping) -> Object
    def visit_grouping(grouping)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Literal literal) -> Object
    def visit_literal(literal)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Unary unary) -> Object
    def visit_unary(unary)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Operator operator) -> Object
    def visit_operator(operator)
      raise NotImplementedError, "Subclasses must implement this method"
    end
  end
end
