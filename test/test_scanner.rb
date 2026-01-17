# frozen_string_literal: true

require "test_helper"

module Rlox
  class TestScanner < Minitest::Test
    def test_scan_empty
      scanner = Scanner.new("")
      tokens = scanner.scan_tokens

      assert_equal 1, tokens.length
      assert_equal Token.new(:EOF, "", nil, 1), tokens[0]
    end

    def test_scan_parens
      scanner = Scanner.new("()")
      tokens = scanner.scan_tokens

      assert_equal 3, tokens.length
      assert_equal [:LEFT_PAREN, :RIGHT_PAREN, :EOF], tokens.map(&:type)
    end

    def test_scan_brackets
      scanner = Scanner.new("[]")
      tokens = scanner.scan_tokens

      assert_equal 3, tokens.length
      assert_equal [:LEFT_BRACKET, :RIGHT_BRACKET, :EOF], tokens.map(&:type)
    end

    def test_scan_curly_brackets
      scanner = Scanner.new("{}")
      tokens = scanner.scan_tokens

      assert_equal 3, tokens.length
      assert_equal [:LEFT_CURLY_BRACE, :RIGHT_CURLY_BRACE, :EOF], tokens.map(&:type)
    end
  end
end
