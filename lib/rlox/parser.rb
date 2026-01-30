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

    #: -> Array[Expr]
    def parse
      [expression]
    end

    private

    #: Array[Token]
    attr_reader :tokens

    #: Integer
    attr_reader :current

    # BNF: expression → equality
    #
    #: -> Expr
    def expression
      equality
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
        expression = Binary.new(expression, operator, right)
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

      while match?(:LESS, :LESS_EQUAL, :GREATER, :GREATER_EQUAL)
        operator = previous.type
        right = term
        expression = Binary.new(expression, operator, right)
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
        expression = Binary.new(expression, operator, right)
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
        expression = Binary.new(expression, operator, right)
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
        return Unary.new(operator, right)
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
      return Literal.new(false) if match?(:FALSE)
      return Literal.new(true) if match?(:TRUE)
      return Literal.new(nil) if match?(:NIL)
      return Literal.new(previous.literal) if match?(:NUMBER, :STRING)

      return unless match?(:LEFT_PAREN)

      expr = expression
      consume(:RIGHT_PAREN, "Expected ')' after expression")
      Grouping.new(expr)
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
