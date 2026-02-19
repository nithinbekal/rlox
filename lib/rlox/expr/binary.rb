# frozen_string_literal: true
# typed: true

module Rlox
  class Expr
    class Binary < Expr
      #: (Expr left, Symbol operator, Expr right) -> void
      def initialize(left, operator, right)
        @left = left
        @operator = operator
        @right = right
      end

      #: Expr
      attr_reader :left

      #: Symbol
      attr_reader :operator

      #: Expr
      attr_reader :right

      def accept(visitor)
        visitor.visit_binary(self)
      end

      #: (Object other) -> bool
      def ==(other)
        other.is_a?(Binary) &&
          @left == other.left &&
          @operator == other.operator &&
          @right == other.right
      end
    end
  end
end
