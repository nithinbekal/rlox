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
    #: (Expr, Symbol, Expr) -> void
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
      return false unless other.is_a?(Binary)

      binary = other #: as Binary

      @left == binary.left &&
        @operator == binary.operator &&
        @right == binary.right
    end
  end

  class Grouping < Expr
    #: (Expr) -> void
    def initialize(expression)
      @expression = expression
    end

    #: Expr
    attr_reader :expression

    def accept(visitor)
      visitor.visit_grouping(self)
    end

    #: (Object) -> bool
    def ==(other)
      other.is_a?(Grouping) && @expression == other.expression
    end
  end

  class Literal < Expr
    #: (Object) -> void
    def initialize(value)
      @value = value
    end

    #: Object
    attr_reader :value

    def accept(visitor)
      visitor.visit_literal(self)
    end

    #: (Object) -> bool
    def ==(other)
      return false unless other.is_a?(Literal)

      literal = other #: as Literal

      @value == literal.value
    end
  end

  class Unary < Expr
    #: (Symbol, Expr) -> void
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

    #: (Object) -> bool
    def ==(other)
      other.is_a?(Unary) && @operator == other.operator && @right == other.right
    end
  end

  class Operator < Expr
    #: (Expr, Symbol, Expr) -> void
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

    #: (Object) -> bool
    def ==(other)
      return false unless other.is_a?(Operator)

      operator = other #: as Operator

      @left == operator.left && @operator == operator.operator && @right == operator.right
    end
  end
end
