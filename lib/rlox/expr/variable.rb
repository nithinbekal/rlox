# frozen_string_literal: true
# typed: true

module Rlox
  class Expr
    class Variable < Expr
      #: (Token name) -> void
      def initialize(name)
        @name = name
      end

      #: Token
      attr_reader :name

      def accept(visitor)
        visitor.visit_variable(self)
      end
    end
  end
end
