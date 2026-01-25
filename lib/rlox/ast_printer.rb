# frozen_string_literal: true

module Rlox
  class AstPrinter
    def print(statements)
      statements.map { |statement| statement.accept(self) }.join("\n")
    end

    def visit_binary(expr)
      "#{expr.operator} #{expr.left.accept(self)} #{expr.right.accept(self)}"
    end

    def visit_grouping(expr)
      "(#{expr.expression.accept(self)})"
    end

    def visit_literal(expr)
      expr.value.to_s
    end

    def visit_unary(expr)
      "#{expr.operator}#{expr.right.accept(self)}"
    end

    def visit_operator(expr)
      "#{expr.left.accept(self)} #{expr.operator} #{expr.right.accept(self)}"
    end
  end
end
