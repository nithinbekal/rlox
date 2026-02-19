# frozen_string_literal: true
# typed: true

module Rlox
  class Statement
    class Block < Statement
      #: (Array[Statement] statements) -> void
      def initialize(statements)
        @statements = statements
      end

      #: Array[Statement]
      attr_reader :statements

      def accept(visitor)
        visitor.visit_block(self)
      end
    end
  end
end
