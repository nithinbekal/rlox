# frozen_string_literal: true
# typed: true

module Rlox
  class Statement
    class Print < Statement
      def initialize(expression)
        @expression = expression
      end

      attr_reader :expression

      def accept(visitor)
        visitor.visit_print(self)
      end
    end
  end
end
