# frozen_string_literal: true

require "test_helper"

module Rlox
  class TestLox < Minitest::Test
    def test_run_literal
      assert_equal 1, Rlox.run("1;")
    end

    def test_arithmetic_expressions
      assert_equal 3, Rlox.run("1 + 2;")
      assert_equal(-1, Rlox.run("1 - 2;"))
      assert_equal 2, Rlox.run("1 * 2;")
      assert_equal 0.5, Rlox.run("1 / 2;")
    end

    def test_arithmetic_expressions_with_multiple_operations
      assert_equal 7, Rlox.run("1 + 2 * 3;")
      assert_equal 5, Rlox.run("1 * 2 + 3;")
      assert_equal 11, Rlox.run("1 + 2 * 3 + 4;")
      assert_equal 14, Rlox.run("1 * 2 + 3 * 4;")
    end

    def test_comparison_expressions
      assert_equal true, Rlox.run("1 < 2;")
      assert_equal true, Rlox.run("1 <= 2;")
      assert_equal false, Rlox.run("1 > 2;")
      assert_equal false, Rlox.run("1 >= 2;")
      assert_equal true, Rlox.run("1 == 1;")
      assert_equal true, Rlox.run("1 != 2;")
    end

    def test_grouped_expressions
      assert_equal 9, Rlox.run("(1 + 2) * 3;")
      assert_equal 7, Rlox.run("1 + (2 * 3);")
      assert_equal 24, Rlox.run("2 + (3 * 5) + 7;")
    end

    def test_unary_expressions
      assert_equal(-1, Rlox.run("-1;"))
      assert_equal true, Rlox.run("!false;")
      assert_equal false, Rlox.run("!true;")
      assert_equal true, Rlox.run("!nil;")
    end

    def test_print_statement
      output = capture_io { Rlox.run("print 42;") }
      assert_equal "42\n", output[0]
    end

    def test_multiple_statements
      output = capture_io { Rlox.run("print 1; print 2;") }
      assert_equal "1\n2\n", output[0]
    end

    def test_var_declaration_with_initializer
      output = capture_io { Rlox.run("var a = 42; print a;") }
      assert_equal "42\n", output[0]
    end

    def test_var_declaration_without_initializer
      output = capture_io { Rlox.run("var x; print x;") }
      assert_equal "nil\n", output[0]
    end

    def test_var_declaration_with_string
      output = capture_io { Rlox.run('var name = "Alice"; print name;') }
      assert_equal "Alice\n", output[0]
    end

    def test_multiple_var_declarations
      output = capture_io { Rlox.run("var a = 1; var b = 2; print a + b;") }
      assert_equal "3\n", output[0]
    end

    def test_var_with_expression_initializer
      output = capture_io { Rlox.run("var sum = 1 + 2 * 3; print sum;") }
      assert_equal "7\n", output[0]
    end

    def test_var_redeclaration
      output = capture_io { Rlox.run("var a = 1; print a; var a = 2; print a;") }
      assert_equal "1\n2\n", output[0]
    end

    def test_undefined_variable_error
      error = assert_raises(RuntimeError) do
        Rlox.run("print x;")
      end
      assert_equal "Undefined variable 'x'.", error.message
    end

    def test_var_in_expression
      output = capture_io { Rlox.run("var a = 5; var b = 3; print a * b + 2;") }
      assert_equal "17\n", output[0]
    end

    def test_var_with_variable_initializer
      output = capture_io { Rlox.run("var a = 10; var b = a; print b;") }
      assert_equal "10\n", output[0]
    end

    def test_var_with_boolean
      output = capture_io { Rlox.run("var flag = true; print flag;") }
      assert_equal "true\n", output[0]
    end

    def test_assignment_updates_variable
      output = capture_io { Rlox.run("var a = 1; a = 2; print a;") }
      assert_equal "2\n", output[0]
    end

    def test_assignment_returns_value
      output = capture_io { Rlox.run("var a; print a = 42;") }
      assert_equal "42\n", output[0]
    end

    def test_chained_assignment
      output = capture_io { Rlox.run("var a; var b; a = b = 5; print a; print b;") }
      assert_equal "5\n5\n", output[0]
    end

    def test_assignment_to_undefined_variable
      error = assert_raises(RuntimeError) { Rlox.run("a = 1;") }
      assert_equal "Undefined variable 'a'.", error.message
    end

    def test_invalid_assignment_target
      assert_raises(ParserError) { Rlox.run("1 = 2;") }
    end

    def test_assignment_with_expression_rhs
      output = capture_io { Rlox.run("var x = 1; x = x + 10; print x;") }
      assert_equal "11\n", output[0]
    end
  end
end
