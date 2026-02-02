# frozen_string_literal: true

require "test_helper"

module Rlox
  class TestLox < Minitest::Test
    def test_run_literal
      assert_equal 1, Rlox.run("1")
    end

    def test_arithmetic_expressions
      assert_equal 3, Rlox.run("1 + 2")
      assert_equal -1, Rlox.run("1 - 2")
      assert_equal 2, Rlox.run("1 * 2")
      assert_equal 0.5, Rlox.run("1 / 2")
    end

    def test_arithmetic_expressions_with_multiple_operations
      assert_equal 7, Rlox.run("1 + 2 * 3")
      assert_equal 5, Rlox.run("1 * 2 + 3")
      assert_equal 11, Rlox.run("1 + 2 * 3 + 4")
      assert_equal 14, Rlox.run("1 * 2 + 3 * 4")
    end

    def test_comparison_expressions
      assert_equal true, Rlox.run("1 < 2")
      assert_equal true, Rlox.run("1 <= 2")
      assert_equal false, Rlox.run("1 > 2")
      assert_equal false, Rlox.run("1 >= 2")
      assert_equal true, Rlox.run("1 == 1")
      assert_equal true, Rlox.run("1 != 2")
    end

    def test_grouped_expressions
      assert_equal 9, Rlox.run("(1 + 2) * 3")
      assert_equal 7, Rlox.run("1 + (2 * 3)")
      assert_equal 24, Rlox.run("2 + (3 * 5) + 7")
    end

    def test_unary_expressions
      assert_equal -1, Rlox.run("-1")
      assert_equal true, Rlox.run("!false")
      assert_equal false, Rlox.run("!true")
      assert_equal true, Rlox.run("!nil")
    end
  end
end
