# frozen_string_literal: true

module Rlox
  #: @abstract
  class Expr
    def accept(visitor)
      raise NotImplementedError, "Subclasses must implement this method"
    end
  end

  class Binary < Expr
    #: (left Expr, operator Symbol, right Expr) -> void
    def initialize(left, operator, right)
      @left = left
      @operator = operator
      @right = right
    end

    attr_reader :left #: Expr
    attr_reader :operator #: Symbol
    attr_reader :right #: Expr

    def accept(visitor)
      visitor.visit_binary(self)
    end
  end

  class Grouping < Expr
    #: (expression Expr) -> void
    def initialize(expression)
      @expression = expression
    end

    attr_reader :expression #: Expr

    def accept(visitor)
      visitor.visit_grouping(self)
    end
  end

  class Literal < Expr
    #: (value Object) -> void
    def initialize(value)
      @value = value
    end

    attr_reader :value #: Object

    def accept(visitor)
      visitor.visit_literal(self)
    end
  end

  class Unary < Expr
    #: (operator Symbol, right Expr) -> void
    def initialize(operator, right)
      @operator = operator
      @right = right
    end

    attr_reader :operator #: Symbol
    attr_reader :right #: Expr

    def accept(visitor)
      visitor.visit_unary(self)
    end
  end

  class Operator < Expr
    #: (left Expr, operator Symbol, right Expr) -> void
    def initialize(left, operator, right)
      @left = left
      @operator = operator
      @right = right
    end

    attr_reader :left #: Expr
    attr_reader :operator #: Symbol
    attr_reader :right #: Expr

    def accept(visitor)
      visitor.visit_operator(self)
    end
  end
end
