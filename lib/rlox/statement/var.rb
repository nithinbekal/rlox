# frozen_string_literal: true
# typed: true

module Rlox
  class Statement
    class Var < Statement
      def initialize(name, initializer)
        @name = name
        @initializer = initializer
      end

      attr_reader :name, :initializer

      def accept(visitor)
        visitor.visit_var(self)
      end
    end
  end
end
