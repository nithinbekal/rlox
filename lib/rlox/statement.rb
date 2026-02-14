# frozen_string_literal: true
# typed: true

module Rlox
  # @abstract
  class Statement
    def accept(visitor)
      raise NotImplementedError, "Subclass must implement accept"
    end
  end

  class Expression < Statement
    def initialize(expression)
      @expression = expression
    end

    attr_reader :expression

    def accept(visitor)
      visitor.visit_expression(self)
    end
  end

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
