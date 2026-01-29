# frozen_string_literal: true

require "test_helper"

module Rlox
  class TestParser < Minitest::Test
    def test_parse_expression
      tokens = [
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:BANG_EQUAL, "!=", nil, 1),
        Token.new(:NUMBER, "2", 2, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      assert_equal [Binary.new(Literal.new(1), :BANG_EQUAL, Literal.new(2))], parser.parse
    end

    def test_parse_expression_with_multiple_operators
      tokens = [
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:BANG_EQUAL, "!=", nil, 1),
        Token.new(:NUMBER, "2", 2, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      assert_equal [Binary.new(Literal.new(1), :BANG_EQUAL, Literal.new(2))], parser.parse
    end

    def test_parse_arithmetic_expression
      tokens = [
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:PLUS, "+", nil, 1),
        Token.new(:NUMBER, "2", 2, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      assert_equal [Binary.new(Literal.new(1), :PLUS, Literal.new(2))], parser.parse
    end

    def test_parse_arithmetic_expression_with_multiple_operators
      tokens = [
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:PLUS, "+", nil, 1),
        Token.new(:NUMBER, "2", 2, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      assert_equal [Binary.new(Literal.new(1), :PLUS, Literal.new(2))], parser.parse
    end

    def test_parse_grouped_expression
      tokens = [
        Token.new(:LEFT_PAREN, "(", nil, 1),
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:RIGHT_PAREN, ")", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      assert_equal [Grouping.new(Literal.new(1))], parser.parse
    end

    def test_parse_grouped_expression_missing_right_paren
      tokens = [
        Token.new(:LEFT_PAREN, "(", nil, 1),
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      error = assert_raises(ParserError) { parser.parse }
      assert_equal "Expected ')' after expression", error.message
    end
  end
end
