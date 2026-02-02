# frozen_string_literal: true
# typed: true

module Rlox
  #: [ReturnType = Object]
  class Interpreter < AstVisitor
    def evaluate(expression)
      expression.accept(self)
    end

    # @override
    #: (Literal literal) -> ReturnType
    def visit_literal(literal)
      literal.value
    end

    # @override
    #: (Grouping grouping) -> ReturnType
    def visit_grouping(grouping)
      evaluate(grouping.expression)
    end

    # @override
    #: (Unary unary) -> ReturnType
    def visit_unary(unary)
      right = evaluate(unary.right)

      case unary.operator
      when :- then -right.value
      when :! then !right.value
      end
    end

    # @override
    #: (Binary binary) -> ReturnType
    def visit_binary(binary)
      left = evaluate(binary.left) #: as Numeric
      right = evaluate(binary.right) #: as Numeric

      case binary.operator
      when :PLUS then left + right
      when :MINUS then left - right
      when :STAR then left * right
      when :SLASH then left / right
      when :EQUAL_EQUAL then left == right
      when :NOT_EQUAL then left != right
      when :LESS then left < right
      when :LESS_EQUAL then left <= right
      when :GREATER then left > right
      when :GREATER_EQUAL then left >= right
      end
    end

    # @override
    #: (Operator operator) -> ReturnType
    def visit_operator(operator)
      left = operator.left.accept(self).value
      right = operator.right.accept(self).value

      binding.irb

      case binary.operator
      when :EQUAL_EQUAL then left == right
      when :NOT_EQUAL then left != right
      when :LESS then left < right
      when :LESS_EQUAL then left <= right
      when :GREATER then left > right
      when :GREATER_EQUAL then left >= right
      end
    end
  end
end
