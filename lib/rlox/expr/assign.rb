# frozen_string_literal: true
# typed: true

module Rlox
  class Expr
    class Assign < Expr
      #: (Token name, Expr value) -> void
      def initialize(name, value)
        @name = name
        @value = value
      end

      #: Token
      attr_reader :name

      #: Expr
      attr_reader :value

      def accept(visitor)
        visitor.visit_assign(self)
      end
    end
  end
end
