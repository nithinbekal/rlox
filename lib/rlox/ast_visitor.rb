# frozen_string_literal: true
# typed: true

module Rlox
  # @abstract
  #: [ReturnType < Object]
  class AstVisitor
    # @abstract
    #: (Binary binary) -> ReturnType
    def visit_binary(binary)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Grouping grouping) -> ReturnType
    def visit_grouping(grouping)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Literal literal) -> ReturnType
    def visit_literal(literal)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Unary unary) -> ReturnType
    def visit_unary(unary)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Expression stmt) -> void
    def visit_expression(stmt)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Print stmt) -> void
    def visit_print(stmt)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Var var_stmt) -> void
    def visit_var(var_stmt)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Variable variable) -> ReturnType
    def visit_variable(variable)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    #: (Assign assign) -> ReturnType
    def visit_assign(assign)
      raise NotImplementedError, "Subclasses must implement this method"
    end
  end
end
