# frozen_string_literal: true
# typed: true

module Rlox
  class AstPrinter
    include AstVisitor

    #: (Array[Expr] statements) -> String
    def print(statements)
      statements.map { |statement| statement.accept(self) }.join("\n")
    end

    # @override
    #: (Binary binary) -> String
    def visit_binary(binary)
      "#{binary.operator} #{binary.left.accept(self)} #{binary.right.accept(self)}"
    end

    # @override
    #: (Grouping grouping) -> String
    def visit_grouping(grouping)
      "(#{grouping.expression.accept(self)})"
    end

    # @override
    #: (Literal literal) -> String
    def visit_literal(literal)
      literal.value.to_s
    end

    # @override
    #: (Unary unary) -> String
    def visit_unary(unary)
      "#{unary.operator}#{unary.right.accept(self)}"
    end

    # @override
    #: (Operator operator) -> String
    def visit_operator(operator)
      "#{operator.left.accept(self)} #{operator.operator} #{operator.right.accept(self)}"
    end
  end
end
