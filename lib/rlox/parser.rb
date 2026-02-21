# frozen_string_literal: true
# typed: true

module Rlox
  # A recursive descent parser for the Lox programming language.
  class Parser
    #: (Array[Token] tokens) -> void
    def initialize(tokens)
      @tokens = tokens
      @current = 0
    end

    #: -> Array[Statement]
    def parse
      statements = []
      statements << declaration until at_end?
      statements
    end

    private

    #: Array[Token]
    attr_reader :tokens

    #: Integer
    attr_reader :current

    #: -> Statement
    def declaration
      if match?(:VAR)
        var_declaration
      else
        statement
      end
    end

    #: -> Statement
    def var_declaration
      name = consume(:IDENTIFIER, "Expected variable name")
      initializer = expression if match?(:EQUAL)

      consume(:SEMICOLON, "Expected ';' after variable declaration")
      Statement::Var.new(name, initializer)
    end

    #: -> Statement
    def statement
      return if_statement if match?(:IF)
      return while_statement if match?(:WHILE)
      return print_statement if match?(:PRINT)
      return Statement::Block.new(block) if match?(:LEFT_CURLY_BRACE)

      expression_statement
    end

    #: -> Array[Statement]
    def block
      statements = []

      statements << declaration until check?(:RIGHT_CURLY_BRACE) || at_end?

      consume(:RIGHT_CURLY_BRACE, "Expected '}' after block")

      statements
    end

    #: (Symbol type) -> bool
    def check?(type)
      !at_end? && peek.type == type
    end

    #: -> Statement
    def if_statement
      consume(:LEFT_PAREN, "Expected '(' after 'if'")
      condition = expression
      consume(:RIGHT_PAREN, "Expected ')' after condition")

      then_branch = statement
      else_branch = statement if match?(:ELSE)

      Statement::If.new(condition, then_branch, else_branch)
    end

    #: -> Statement
    def while_statement
      consume(:LEFT_PAREN, "Expected '(' after 'while'")
      condition = expression

      consume(:RIGHT_PAREN, "Expected ')' after condition")
      body = statement

      Statement::While.new(condition, body)
    end

    #: -> Statement
    def print_statement
      value = expression
      consume(:SEMICOLON, "Expected ';' after expression")
      Statement::Print.new(value)
    end

    #: -> Statement
    def expression_statement
      expr = expression
      consume(:SEMICOLON, "Expected ';' after expression")
      Statement::Expression.new(expr)
    end

    # BNF: expression → equality
    #
    #: -> Expr
    def expression
      assignment
    end

    # BNF: assignment → variable "=" assignment | equality
    #
    #: -> Expr
    def assignment
      expr = or_expr
      return expr unless match?(:EQUAL)

      previous
      value = assignment

      raise ParserError, "Invalid assignment target." unless expr.is_a?(Expr::Variable)

      Expr::Assign.new(expr.name, value)
    end

    # BNF: or_expr → and_expr ( "or" and_expr )*
    #
    #: -> Expr
    def or_expr
      expr = and_expr

      while match?(:OR)
        operator = previous.type
        right = and_expr
        expr = Expr::Logical.new(expr, operator, right)
      end

      expr
    end

    # BNF: and_expr → equality ( "and" equality )*
    #
    #: -> Expr
    def and_expr
      expr = equality

      while match?(:AND)
        operator = previous.type
        right = equality
        expr = Expr::Logical.new(expr, operator, right)
      end

      expr
    end

    # BNF: equality → comparison ( ( "!=" | "==" ) comparison )*
    #
    # Examples:
    #   1 == 2
    #   1 != 2
    #
    #: -> Expr
    def equality
      expression = comparison

      while match?(:BANG_EQUAL, :EQUAL_EQUAL)
        operator = previous.type
        right = comparison
        expression = Expr::Binary.new(expression, operator, right)
      end

      expression
    end

    # BNF: comparison → term ( ( ">" | ">=" | "<" | "<=" ) term )*
    #
    # Examples:
    #   1 > 2
    #   1 >= 2
    #
    #: -> Expr
    def comparison
      expression = term

      while match?(:LESS, :LESS_EQUAL, :GREATER, :GREATER_EQUAL, :NOT_EQUAL)
        operator = previous.type
        right = term
        expression = Expr::Binary.new(expression, operator, right)
      end

      expression
    end

    # BNF: term → factor ( ( "-" | "+" ) factor )*
    #
    # Examples:
    #   1 - 2
    #   1 + 2
    #
    #: -> Expr
    def term
      expression = factor

      while match?(:MINUS, :PLUS)
        operator = previous.type
        right = factor
        expression = Expr::Binary.new(expression, operator, right)
      end

      expression
    end

    # BNF: factor → unary ( ( "/" | "*" ) unary )*
    #
    # Examples:
    #   1 / 2
    #   1 * 2
    #
    #: -> Expr
    def factor
      expression = unary

      while match?(:SLASH, :STAR)
        operator = previous.type
        right = unary
        expression = Expr::Binary.new(expression, operator, right)
      end

      expression
    end

    # BNF: unary → ( "!" | "-" ) unary | primary
    #
    # Examples:
    #   !1
    #   -1
    #
    #: -> Expr
    def unary
      if match?(:BANG, :MINUS)
        operator = previous.type
        right = unary
        return Expr::Unary.new(operator, right)
      end

      primary #: as !nil
    end

    # primary → NUMBER | STRING | "true" | "false" | "nil" | "(" expression ")"
    #
    # Examples:
    #   1
    #   "hello"
    #   true
    #   false
    #   nil
    #   (1 + 2)
    #
    #: -> Expr?
    def primary
      return Expr::Literal.new(false) if match?(:FALSE)
      return Expr::Literal.new(true) if match?(:TRUE)
      return Expr::Literal.new(nil) if match?(:NIL)
      return Expr::Literal.new(previous.literal) if match?(:NUMBER, :STRING)
      return Expr::Variable.new(previous) if match?(:IDENTIFIER)

      return unless match?(:LEFT_PAREN)

      expr = expression
      consume(:RIGHT_PAREN, "Expected ')' after expression")
      Expr::Grouping.new(expr)
    end

    #: -> void
    def synchronize
      advance

      until at_end?
        return if previous.type == :SEMICOLON
        return if [:CLASS, :FUN, :VAR, :FOR, :IF, :WHILE, :PRINT, :RETURN].include?(peek.type)

        advance
      end
    end

    #: (*Symbol) -> bool
    def match?(*types)
      types.any? do |type|
        if peek.type == type
          @current += 1
          return true
        end
      end

      false
    end

    #: -> void
    def advance
      @current += 1
    end

    #: -> Token
    def previous
      @tokens[@current - 1] #: as !nil
    end

    #: -> Token
    def peek
      if @current < @tokens.length
        return @tokens[@current] #: as !nil
      end

      @tokens[-1] #: as !nil
    end

    #: (Symbol type, String message) -> void
    def consume(type, message)
      return previous if match?(type)

      raise ParserError, message
    end

    #: -> bool
    def at_end? = peek.type == :EOF
  end
end
