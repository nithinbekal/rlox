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

    #: (other Object) -> bool
    def ==(other)
      other.is_a?(Binary) &&
        @left == other.left &&
        @operator == other.operator &&
        @right == other.right
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

    #: (other Object) -> bool
    def ==(other)
      other.is_a?(Grouping) && @expression == other.expression
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

    #: (other Object) -> bool
    def ==(other)
      other.is_a?(Literal) && @value == other.value
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

    #: (other Object) -> bool
    def ==(other)
      other.is_a?(Unary) && @operator == other.operator && @right == other.right
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

    #: (other Object) -> bool
    def ==(other)
      other.is_a?(Operator) && @left == other.left && @operator == other.operator && @right == other.right
    end
  end
end
