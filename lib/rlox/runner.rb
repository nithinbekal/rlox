# # frozen_string_literal: true

module Rlox
  class Runner
    def run_file(path)
      source = File.read(path)
      run_source(source)
    rescue Errno::ENOENT
      warn "Error: Could not find file '#{path}'"
      exit 66
    end

    def run_source(source)
      scanner = Rlox::Scanner.new(source)
      tokens = scanner.scan_tokens
      parser = Rlox::Parser.new(tokens)
      expression = parser.parse

      printer = Rlox::AstPrinter.new
      printer.print(expression)
    end
  end
end
