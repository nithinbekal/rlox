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
      assert_instance_of Statement::Expression, statements[0]
      assert_instance_of Expr::Binary, statements[0].expression
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
      assert_instance_of Statement::Expression, statements[0]
      assert_instance_of Statement::Expression, statements[1]
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
      assert_instance_of Statement::Print, statements[0]
      assert_instance_of Expr::Literal, statements[0].expression
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
      assert_instance_of Statement::Print, statements[0]
      assert_instance_of Expr::Binary, statements[0].expression
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
      assert_instance_of Statement::Print, statements[0]
      assert_instance_of Statement::Print, statements[1]
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
      assert_instance_of Statement::Print, statements[0]
      assert_instance_of Statement::Expression, statements[1]
      assert_instance_of Statement::Print, statements[2]
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
      assert_instance_of Statement::Expression, statements[0]
      assert_instance_of Expr::Binary, statements[0].expression
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

    def test_parse_var_declaration_with_initializer
      tokens = [
        Token.new(:VAR, "var", nil, 1),
        Token.new(:IDENTIFIER, "a", "a", 1),
        Token.new(:EQUAL, "=", nil, 1),
        Token.new(:NUMBER, "42", 42, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 1, statements.length
      assert_instance_of Statement::Var, statements[0]
      assert_equal "a", statements[0].name.lexeme
      assert_instance_of Expr::Literal, statements[0].initializer
      assert_equal 42, statements[0].initializer.value
    end

    def test_parse_var_declaration_without_initializer
      tokens = [
        Token.new(:VAR, "var", nil, 1),
        Token.new(:IDENTIFIER, "x", "x", 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 1, statements.length
      assert_instance_of Statement::Var, statements[0]
      assert_equal "x", statements[0].name.lexeme
      assert_nil statements[0].initializer
    end

    def test_parse_var_declaration_with_expression_initializer
      tokens = [
        Token.new(:VAR, "var", nil, 1),
        Token.new(:IDENTIFIER, "sum", "sum", 1),
        Token.new(:EQUAL, "=", nil, 1),
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:PLUS, "+", nil, 1),
        Token.new(:NUMBER, "2", 2, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 1, statements.length
      assert_instance_of Statement::Var, statements[0]
      assert_equal "sum", statements[0].name.lexeme
      assert_instance_of Expr::Binary, statements[0].initializer
      assert_equal :PLUS, statements[0].initializer.operator
    end

    def test_parse_multiple_var_declarations
      tokens = [
        Token.new(:VAR, "var", nil, 1),
        Token.new(:IDENTIFIER, "a", "a", 1),
        Token.new(:EQUAL, "=", nil, 1),
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:VAR, "var", nil, 1),
        Token.new(:IDENTIFIER, "b", "b", 1),
        Token.new(:EQUAL, "=", nil, 1),
        Token.new(:NUMBER, "2", 2, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 2, statements.length
      assert_instance_of Statement::Var, statements[0]
      assert_instance_of Statement::Var, statements[1]
      assert_equal "a", statements[0].name.lexeme
      assert_equal "b", statements[1].name.lexeme
    end

    def test_parse_var_declaration_missing_semicolon
      tokens = [
        Token.new(:VAR, "var", nil, 1),
        Token.new(:IDENTIFIER, "a", "a", 1),
        Token.new(:EQUAL, "=", nil, 1),
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      error = assert_raises(ParserError) { parser.parse }
      assert_equal "Expected ';' after variable declaration", error.message
    end

    def test_parse_var_declaration_missing_name
      tokens = [
        Token.new(:VAR, "var", nil, 1),
        Token.new(:EQUAL, "=", nil, 1),
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      error = assert_raises(ParserError) { parser.parse }
      assert_equal "Expected variable name", error.message
    end

    # Tests for variable expressions
    def test_parse_variable_expression
      tokens = [
        Token.new(:IDENTIFIER, "myVar", "myVar", 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 1, statements.length
      assert_instance_of Statement::Expression, statements[0]
      assert_instance_of Expr::Variable, statements[0].expression
      assert_equal "myVar", statements[0].expression.name.lexeme
    end

    def test_parse_variable_in_binary_expression
      tokens = [
        Token.new(:IDENTIFIER, "a", "a", 1),
        Token.new(:PLUS, "+", nil, 1),
        Token.new(:IDENTIFIER, "b", "b", 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 1, statements.length
      assert_instance_of Statement::Expression, statements[0]
      assert_instance_of Expr::Binary, statements[0].expression
      assert_instance_of Expr::Variable, statements[0].expression.left
      assert_instance_of Expr::Variable, statements[0].expression.right
      assert_equal "a", statements[0].expression.left.name.lexeme
      assert_equal "b", statements[0].expression.right.name.lexeme
    end

    def test_parse_print_variable
      tokens = [
        Token.new(:PRINT, "print", nil, 1),
        Token.new(:IDENTIFIER, "x", "x", 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 1, statements.length
      assert_instance_of Statement::Print, statements[0]
      assert_instance_of Expr::Variable, statements[0].expression
      assert_equal "x", statements[0].expression.name.lexeme
    end

    def test_parse_mixed_var_and_other_statements
      tokens = [
        Token.new(:VAR, "var", nil, 1),
        Token.new(:IDENTIFIER, "a", "a", 1),
        Token.new(:EQUAL, "=", nil, 1),
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:PRINT, "print", nil, 1),
        Token.new(:IDENTIFIER, "a", "a", 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 2, statements.length
      assert_instance_of Statement::Var, statements[0]
      assert_instance_of Statement::Print, statements[1]
    end

    # Tests for assignment expressions
    def test_parse_assignment_to_variable
      tokens = [
        Token.new(:IDENTIFIER, "a", "a", 1),
        Token.new(:EQUAL, "=", nil, 1),
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 1, statements.length
      assert_instance_of Statement::Expression, statements[0]
      assert_instance_of Expr::Assign, statements[0].expression
      assert_equal "a", statements[0].expression.name.lexeme
      assert_instance_of Expr::Literal, statements[0].expression.value
      assert_equal 1, statements[0].expression.value.value
    end

    def test_parse_assignment_with_variable_rhs
      tokens = [
        Token.new(:IDENTIFIER, "a", "a", 1),
        Token.new(:EQUAL, "=", nil, 1),
        Token.new(:IDENTIFIER, "b", "b", 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 1, statements.length
      assert_instance_of Expr::Assign, statements[0].expression
      assert_equal "a", statements[0].expression.name.lexeme
      assert_instance_of Expr::Variable, statements[0].expression.value
      assert_equal "b", statements[0].expression.value.name.lexeme
    end

    def test_parse_assignment_with_expression_rhs
      tokens = [
        Token.new(:IDENTIFIER, "a", "a", 1),
        Token.new(:EQUAL, "=", nil, 1),
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:PLUS, "+", nil, 1),
        Token.new(:NUMBER, "2", 2, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 1, statements.length
      assert_instance_of Expr::Assign, statements[0].expression
      assert_equal "a", statements[0].expression.name.lexeme
      assert_instance_of Expr::Binary, statements[0].expression.value
      assert_equal :PLUS, statements[0].expression.value.operator
    end

    def test_parse_chained_assignment
      # a = b = 1 is right-associative: a = (b = 1)
      tokens = [
        Token.new(:IDENTIFIER, "a", "a", 1),
        Token.new(:EQUAL, "=", nil, 1),
        Token.new(:IDENTIFIER, "b", "b", 1),
        Token.new(:EQUAL, "=", nil, 1),
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      statements = parser.parse

      assert_equal 1, statements.length
      outer = statements[0].expression
      assert_instance_of Expr::Assign, outer
      assert_equal "a", outer.name.lexeme
      inner = outer.value
      assert_instance_of Expr::Assign, inner
      assert_equal "b", inner.name.lexeme
      assert_instance_of Expr::Literal, inner.value
      assert_equal 1, inner.value.value
    end

    def test_parse_invalid_assignment_target
      tokens = [
        Token.new(:NUMBER, "1", 1, 1),
        Token.new(:EQUAL, "=", nil, 1),
        Token.new(:NUMBER, "2", 2, 1),
        Token.new(:SEMICOLON, ";", nil, 1),
        Token.new(:EOF, "", nil, 1),
      ]
      parser = Parser.new(tokens)
      error = assert_raises(ParserError) { parser.parse }
      assert_equal "Invalid assignment target.", error.message
    end
  end
end
