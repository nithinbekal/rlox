# frozen_string_literal: true
# typed: true

module Rlox
  class Expr
    class Unary < Expr
      #: (Symbol operator, Expr right) -> void
      def initialize(operator, right)
        @operator = operator
        @right = right
      end

      #: Symbol
      attr_reader :operator

      #: Expr
      attr_reader :right

      def accept(visitor)
        visitor.visit_unary(self)
      end

      #: (Object other) -> bool
      def ==(other)
        other.is_a?(Unary) && @operator == other.operator && @right == other.right
      end
    end
  end
end
