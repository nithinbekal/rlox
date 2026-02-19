# frozen_string_literal: true
# typed: true

module Rlox
  class Statement
    class Expression < Statement
      def initialize(expression)
        @expression = expression
      end

      attr_reader :expression

      def accept(visitor)
        visitor.visit_expression(self)
      end
    end
  end
end
