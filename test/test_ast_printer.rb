# frozen_string_literal: true

require "test_helper"

module Rlox
  class TestAstPrinter < Minitest::Test
    def test_print_binary
      printer = AstPrinter.new
      assert_equal "+ 1 2", printer.print([Binary.new(Literal.new(1), :+, Literal.new(2))])
    end

    def test_print_grouping
      printer = AstPrinter.new
      assert_equal "(+ 1 2)", printer.print([Grouping.new(Binary.new(Literal.new(1), :+, Literal.new(2)))])
    end

    def test_print_literal
      printer = AstPrinter.new
      assert_equal "1", printer.print([Literal.new(1)])
    end

    def test_print_unary
      printer = AstPrinter.new
      assert_equal "-1", printer.print([Unary.new(:-, Literal.new(1))])
    end

    def test_print_multiple_statements
      printer = AstPrinter.new
      output = printer.print([
        Binary.new(Literal.new(1), :+, Literal.new(2)),
        Binary.new(Literal.new(3), :+, Literal.new(4)),
      ])
      assert_equal "+ 1 2\n+ 3 4", output
    end
  end
end
