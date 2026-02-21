# frozen_string_literal: true
# typed: true

module Rlox
  class Statement
    class If < Statement
      #: (Expr condition, Statement then_branch, Statement else_branch) -> void
      def initialize(condition, then_branch, else_branch)
        @condition = condition
        @then_branch = then_branch
        @else_branch = else_branch
      end

      #: Expr
      attr_reader :condition

      #: Statement
      attr_reader :then_branch

      #: Statement
      attr_reader :else_branch

      def accept(visitor)
        visitor.visit_if_statement(self)
      end
    end
  end
end
