# frozen_string_literal: true

require_relative "rlox/version"
require_relative "rlox/scanner"
require_relative "rlox/token"
require_relative "rlox/expr"
require_relative "rlox/ast_visitor"
require_relative "rlox/ast_printer"
require_relative "rlox/parser"
require_relative "rlox/interpreter"

module Rlox
  class Error < StandardError; end
  class ParserError < Error; end

  def self.run(source)
    scanner = Rlox::Scanner.new(source)
    tokens = scanner.scan_tokens
    parser = Rlox::Parser.new(tokens)
    expressions = parser.parse

    return if expressions.nil?

    interpreter = Rlox::Interpreter.new
    interpreter.evaluate(expressions.first)
  end
end
