# frozen_string_literal: true

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup

module Rlox
  class Error < StandardError; end
  class ParserError < Error; end

  def self.run(source)
    scanner = Rlox::Scanner.new(source)
    tokens = scanner.scan_tokens
    parser = Rlox::Parser.new(tokens)
    statements = parser.parse

    return if statements.nil? || statements.empty?

    interpreter = Rlox::Interpreter.new

    # For backward compatibility with tests: if there's only one expression statement,
    # return its value. Otherwise, execute all statements and return nil.
    if statements.length == 1 && statements.first.is_a?(Statement::Expression)
      interpreter.evaluate(statements.first.expression)
    else
      statements.each { |stmt| interpreter.execute(stmt) }
      nil
    end
  end
end
