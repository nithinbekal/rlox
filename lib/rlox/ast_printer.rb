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
    #: (Expr::Binary binary) -> ReturnType
    def visit_binary(binary)
      "#{binary.operator} #{binary.left.accept(self)} #{binary.right.accept(self)}"
    end

    # @override
    #: (Expr::Grouping grouping) -> ReturnType
    def visit_grouping(grouping)
      "(#{grouping.expression.accept(self)})"
    end

    # @override
    #: (Expr::Literal literal) -> ReturnType
    def visit_literal(literal)
      literal.value.to_s
    end

    # @override
    #: (Expr::Unary unary) -> ReturnType
    def visit_unary(unary)
      "#{unary.operator}#{unary.right.accept(self)}"
    end

    # @override
    #: (Statement::Expression stmt) -> ReturnType
    def visit_expression(stmt)
      stmt.expression.accept(self)
    end

    # @override
    #: (Statement::Print stmt) -> ReturnType
    def visit_print(stmt)
      "print #{stmt.expression.accept(self)}"
    end

    # @override
    #: (Statement::Var var_stmt) -> ReturnType
    def visit_var(var_stmt)
      initializer = var_stmt.initializer ? " = #{var_stmt.initializer.accept(self)}" : ""
      "var #{var_stmt.name.lexeme}#{initializer}"
    end

    # @override
    #: (Expr::Variable variable) -> ReturnType
    def visit_variable(variable)
      variable.name.lexeme
    end

    # @override
    #: (Expr::Assign assign) -> ReturnType
    def visit_assign(assign)
      "#{assign.name.lexeme} = #{assign.value.accept(self)}"
    end

    # @override
    #: (Statement::Block block_statement) -> ReturnType
    def visit_block(block_statement)
      block_statement.statements.map { |statement| statement.accept(self) }.join("\n")
    end

    # @override
    #: (Statement::If if_statement) -> ReturnType
    def visit_if_statement(if_statement)
      "if #{if_statement.condition.accept(self)} #{if_statement.then_branch.accept(self)} " \
        "#{if_statement.else_branch.accept(self)}"
    end

    # @override
    #: (Expr::Logical logical) -> ReturnType
    def visit_logical(logical)
      "#{logical.operator} #{logical.left.accept(self)} #{logical.right.accept(self)}"
    end
  end
end
