# frozen_string_literal: true
# typed: true

module Rlox
  class Expr
    class Grouping < Expr
      #: (Expr expression) -> void
      def initialize(expression)
        @expression = expression
      end

      #: Expr
      attr_reader :expression

      def accept(visitor)
        visitor.visit_grouping(self)
      end

      #: (Object other) -> bool
      def ==(other)
        other.is_a?(Grouping) && @expression == other.expression
      end
    end
  end
end
