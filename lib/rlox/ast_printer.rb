# frozen_string_literal: true
# typed: true

module Rlox
  #: [ReturnType = String]
  class AstPrinter < AstVisitor
    #: (Array[Expr] statements) -> ReturnType
    def print(statements)
      statements.map { |statement| statement.accept(self) }.join("\n")
    end

    # @override
    #: (Binary binary) -> ReturnType
    def visit_binary(binary)
      "#{binary.operator} #{binary.left.accept(self)} #{binary.right.accept(self)}"
    end

    # @override
    #: (Grouping grouping) -> ReturnType
    def visit_grouping(grouping)
      "(#{grouping.expression.accept(self)})"
    end

    # @override
    #: (Literal literal) -> ReturnType
    def visit_literal(literal)
      literal.value.to_s
    end

    # @override
    #: (Unary unary) -> ReturnType
    def visit_unary(unary)
      "#{unary.operator}#{unary.right.accept(self)}"
    end

    # @override
    #: (Expression stmt) -> ReturnType
    def visit_expression(stmt)
      stmt.expression.accept(self)
    end

    # @override
    #: (Print stmt) -> ReturnType
    def visit_print(stmt)
      "print #{stmt.expression.accept(self)}"
    end

    # @override
    #: (Var var_stmt) -> ReturnType
    def visit_var(var_stmt)
      initializer = var_stmt.initializer ? " = #{var_stmt.initializer.accept(self)}" : ""
      "var #{var_stmt.name.lexeme}#{initializer}"
    end

    # @override
    #: (Variable variable) -> ReturnType
    def visit_variable(variable)
      variable.name.lexeme
    end

    # @override
    #: (Assign assign) -> ReturnType
    def visit_assign(assign)
      "#{assign.name.lexeme} = #{assign.value.accept(self)}"
    end
  end
end
