# frozen_string_literal: true

module Rlox
  # A recursive descent parser for the Lox programming language.
  class Parser
    #: (tokens Array[Token]) -> void
    def initialize(tokens)
      @tokens = tokens
      @current = 0
    end

    #: -> Array[Expr]
    def parse
      [expression]
    end

    private

    attr_reader :tokens #: Array[Token]
    attr_reader :current #: Integer

    #: -> Expr
    def expression
      equality
    end

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

    #: (*types Symbol) -> bool
    def match?(*types)
      types.any? do |type|
        if peek.type == type
          @current += 1
          return true
        end
      end

      false
    end

    #: -> Token
    def previous = @tokens[@current - 1]

    #: -> Token
    def peek
      return @tokens[@current] if @current < @tokens.length

      @tokens[-1]
    end

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

    def term
      expression = factor

      while match?(:MINUS, :PLUS)
        operator = previous.type
        right = factor
        expression = Binary.new(expression, operator, right)
      end

      expression
    end

    def factor
      expression = unary

      while match?(:SLASH, :STAR)
        operator = previous.type
        right = unary
        expression = Binary.new(expression, operator, right)
      end

      expression
    end

    def unary
      if match?(:BANG, :MINUS)
        operator = previous.type
        right = unary
        return Unary.new(operator, right)
      end

      primary
    end

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

    def consume(type, message)
      return previous if match?(type)

      raise ParserError, message
    end
  end
end
