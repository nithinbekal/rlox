# frozen_string_literal: true

require "test_helper"

module Rlox
  class TestParser < Minitest::Test
    # Tests for expression statements
    def test_parse_simple_expression_statement
      tokens = [
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:PLUS, "+", nil, 1),
        Token.new(:NUMBER, "2", 2, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 1, statements.length
      assert_instance_of Expression, statements[0]
      assert_instance_of Binary, statements[0].expression
      assert_equal :PLUS, statements[0].expression.operator
    end

    def test_parse_multiple_expression_statements
      tokens = [
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:NUMBER, "2", 2, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 2, statements.length
      assert_instance_of Expression, statements[0]
      assert_instance_of Expression, statements[1]
      assert_equal 1, statements[0].expression.value
      assert_equal 2, statements[1].expression.value
    end

    def test_parse_expression_statement_missing_semicolon
      tokens = [
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      error = assert_raises(ParserError) { parser.parse }
      assert_equal "Expected ';' after expression", error.message
    end

    # Tests for print statements
    def test_parse_print_statement
      tokens = [
        Token.new(:PRINT, "print", nil, 1),
        Token.new(:NUMBER, "42", 42, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 1, statements.length
      assert_instance_of Print, statements[0]
      assert_instance_of Literal, statements[0].expression
      assert_equal 42, statements[0].expression.value
    end

    def test_parse_print_statement_with_expression
      tokens = [
        Token.new(:PRINT, "print", nil, 1),
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:PLUS, "+", nil, 1),
        Token.new(:NUMBER, "2", 2, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 1, statements.length
      assert_instance_of Print, statements[0]
      assert_instance_of Binary, statements[0].expression
      assert_equal :PLUS, statements[0].expression.operator
    end

    def test_parse_print_statement_missing_semicolon
      tokens = [
        Token.new(:PRINT, "print", nil, 1),
        Token.new(:NUMBER, "42", 42, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      error = assert_raises(ParserError) { parser.parse }
      assert_equal "Expected ';' after expression", error.message
    end

    def test_parse_multiple_print_statements
      tokens = [
        Token.new(:PRINT, "print", nil, 1),
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:PRINT, "print", nil, 1),
        Token.new(:NUMBER, "2", 2, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 2, statements.length
      assert_instance_of Print, statements[0]
      assert_instance_of Print, statements[1]
      assert_equal 1, statements[0].expression.value
      assert_equal 2, statements[1].expression.value
    end

    # Tests for mixed statements
    def test_parse_mixed_statements
      tokens = [
        Token.new(:PRINT, "print", nil, 1),
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:NUMBER, "2", 2, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:PRINT, "print", nil, 1),
        Token.new(:NUMBER, "3", 3, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 3, statements.length
      assert_instance_of Print, statements[0]
      assert_instance_of Expression, statements[1]
      assert_instance_of Print, statements[2]
    end

    # Tests for complex expressions within statements
    def test_parse_statement_with_grouped_expression
      tokens = [
        Token.new(:LEFT_PAREN, "(", nil, 1),
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:PLUS, "+", nil, 1),
        Token.new(:NUMBER, "2", 2, 1),
        Token.new(:RIGHT_PAREN, ")", nil, 1),
        Token.new(:STAR, "*", nil, 1),
        Token.new(:NUMBER, "3", 3, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 1, statements.length
      assert_instance_of Expression, statements[0]
      assert_instance_of Binary, statements[0].expression
      assert_equal :STAR, statements[0].expression.operator
    end

    def test_parse_empty_program
      tokens = [
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 0, statements.length
    end
  end
end
