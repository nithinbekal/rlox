# frozen_string_literal: true

require "test_helper"

module Rlox
  class TestAstPrinter < Minitest::Test
    def test_print_binary
      printer = AstPrinter.new
      assert_equal "+ 1 2", printer.print([Expr::Binary.new(Expr::Literal.new(1), :+, Expr::Literal.new(2))])
    end

    def test_print_grouping
      printer = AstPrinter.new
      assert_equal "(+ 1 2)", printer.print([Expr::Grouping.new(Expr::Binary.new(Expr::Literal.new(1), :+, Expr::Literal.new(2)))])
    end

    def test_print_literal
      printer = AstPrinter.new
      assert_equal "1", printer.print([Expr::Literal.new(1)])
    end

    def test_print_unary
      printer = AstPrinter.new
      assert_equal "-1", printer.print([Expr::Unary.new(:-, Expr::Literal.new(1))])
    end

    def test_print_multiple_statements
      printer = AstPrinter.new
      output = printer.print([
        Expr::Binary.new(Expr::Literal.new(1), :+, Expr::Literal.new(2)),
        Expr::Binary.new(Expr::Literal.new(3), :+, Expr::Literal.new(4)),
      ])
      assert_equal "+ 1 2\n+ 3 4", output
    end
  end
end
