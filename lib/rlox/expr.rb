# frozen_string_literal: true
# typed: true

module Rlox
  # @abstract
  class Expr
    def accept(visitor)
      raise NotImplementedError, "Subclasses must implement this method"
    end
  end

  class Binary < Expr
    #: (Expr left, Symbol operator, Expr right) -> void
    def initialize(left, operator, right)
      @left = left
      @operator = operator
      @right = right
    end

    #: Expr
    attr_reader :left

    #: Symbol
    attr_reader :operator

    #: Expr
    attr_reader :right

    def accept(visitor)
      visitor.visit_binary(self)
    end

    #: (Object other) -> bool
    def ==(other)
      other.is_a?(Binary) &&
        @left == other.left &&
        @operator == other.operator &&
        @right == other.right
    end
  end

  class Grouping < Expr
    #: (Expr expression) -> void
    def initialize(expression)
      @expression = expression
    end

    #: Expr
    attr_reader :expression

    def accept(visitor)
      visitor.visit_grouping(self)
    end

    #: (Object other) -> bool
    def ==(other)
      other.is_a?(Grouping) && @expression == other.expression
    end
  end

  class Literal < Expr
    #: (Object value) -> void
    def initialize(value)
      @value = value
    end

    #: Object
    attr_reader :value

    def accept(visitor)
      visitor.visit_literal(self)
    end

    #: (Object other) -> bool
    def ==(other)
      other.is_a?(Literal) && @value == other.value
    end
  end

  class Unary < Expr
    #: (Symbol operator, Expr right) -> void
    def initialize(operator, right)
      @operator = operator
      @right = right
    end

    #: Symbol
    attr_reader :operator

    #: Expr
    attr_reader :right

    def accept(visitor)
      visitor.visit_unary(self)
    end

    #: (Object other) -> bool
    def ==(other)
      other.is_a?(Unary) && @operator == other.operator && @right == other.right
    end
  end

  class Operator < Expr
    #: (Expr left, Symbol operator, Expr right) -> void
    def initialize(left, operator, right)
      @left = left
      @operator = operator
      @right = right
    end

    #: Expr
    attr_reader :left

    #: Symbol
    attr_reader :operator

    #: Expr
    attr_reader :right

    def accept(visitor)
      visitor.visit_operator(self)
    end

    #: (Object other) -> bool
    def ==(other)
      other.is_a?(Operator) && @left == other.left && @operator == other.operator && @right == other.right
    end
  end
end
