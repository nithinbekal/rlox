# frozen_string_literal: true
# typed: true

module Rlox
  class Expr
    class Logical < Expr
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
        visitor.visit_logical(self)
      end
    end
  end
end
