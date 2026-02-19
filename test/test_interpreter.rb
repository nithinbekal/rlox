# frozen_string_literal: true

require "test_helper"

module Rlox
  class TestInterpreter < Minitest::Test
    def test_evaluate_expression
      interpreter = Interpreter.new
      assert_equal 3, interpreter.evaluate(Expr::Binary.new(Expr::Literal.new(1), :PLUS, Expr::Literal.new(2)))
    end
  end
end
