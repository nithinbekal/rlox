# frozen_string_literal: true
# typed: true

module Rlox
  class Statement
    class While < Statement
      #: (Expr condition, Statement body) -> void
      def initialize(condition, body)
        @condition = condition
        @body = body
      end

      #: Expr
      attr_reader :condition

      #: Statement
      attr_reader :body

      def accept(visitor)
        visitor.visit_while_statement(self)
      end
    end
  end
end
