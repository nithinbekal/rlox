# frozen_string_literal: true
# typed: true

module Rlox
  #: [ReturnType = Object]
  class Interpreter < AstVisitor
    def initialize
      @environment = Environment.new
    end

    def evaluate(expression)
      expression.accept(self)
    end

    def execute(statement)
      statement.accept(self)
    end

    # Statement visitors
    # @override
    #: (Statement::Expression stmt) -> void
    def visit_expression(stmt)
      evaluate(stmt.expression)
      nil
    end

    # @override
    #: (Statement::Print stmt) -> void
    def visit_print(stmt)
      value = evaluate(stmt.expression)
      puts stringify(value)
      nil
    end

    # @override
    #: (Statement::Var stmt) -> void
    def visit_var(stmt)
      value = nil
      value = evaluate(stmt.initializer) if stmt.initializer

      @environment.define(stmt.name.lexeme, value)
      nil
    end

    # @override
    #: (Expr::Assign expr) -> Object
    def visit_assign(expr)
      value = evaluate(expr.value)
      @environment.assign(expr.name.lexeme, value)
      value
    end

    # Expression visitors
    # @override
    #: (Expr::Literal literal) -> ReturnType
    def visit_literal(literal)
      literal.value
    end

    # @override
    #: (Expr::Grouping grouping) -> ReturnType
    def visit_grouping(grouping)
      evaluate(grouping.expression)
    end

    # @override
    #: (Expr::Unary unary) -> ReturnType
    def visit_unary(unary)
      value = evaluate(unary.right)

      case unary.operator
      when :MINUS then -value
      when :BANG then !value
      end
    end

    # @override
    #: (Expr::Binary binary) -> ReturnType
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
    #: (Expr::Variable variable) -> ReturnType
    def visit_variable(variable)
      @environment.get(variable.name.lexeme)
    end

    private

    #: (Object) -> String
    def stringify(value)
      return "nil" if value.nil?

      if value.is_a?(Numeric) && value == value.to_i
        value.to_i.to_s
      else
        value.to_s
      end
    end
  end
end
