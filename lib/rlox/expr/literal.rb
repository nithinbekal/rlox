# frozen_string_literal: true
# typed: true

module Rlox
  class Expr
    class Literal < Expr
      #: (Object value) -> void
      def initialize(value)
        @value = value
      end

      #: Object
      attr_reader :value

      def accept(visitor)
        visitor.visit_literal(self)
      end

      #: (Object other) -> bool
      def ==(other)
        other.is_a?(Literal) && @value == other.value
      end
    end
  end
end
