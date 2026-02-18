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
