# frozen_string_literal: true
# typed: true

module Rlox
  # @abstract
  #: [ReturnType < Object]
  class AstVisitor
    # @abstract
    #: (Expr::Binary binary) -> ReturnType
    def visit_binary(binary)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Expr::Grouping grouping) -> ReturnType
    def visit_grouping(grouping)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Expr::Literal literal) -> ReturnType
    def visit_literal(literal)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Expr::Unary unary) -> ReturnType
    def visit_unary(unary)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Statement::Expression stmt) -> void
    def visit_expression(stmt)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Statement::Print stmt) -> void
    def visit_print(stmt)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Statement::Var var_stmt) -> void
    def visit_var(var_stmt)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Expr::Variable variable) -> ReturnType
    def visit_variable(variable)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Expr::Assign assign) -> ReturnType
    def visit_assign(assign)
      raise NotImplementedError, "Subclasses must implement this method"
    end
  end
end
