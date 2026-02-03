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

    def run_prompt
      puts "Lox REPL - Press Ctrl+C or Ctrl+D to exit"

      loop do
        print "> "
        line = gets
        break if line.nil?

        line = line.chomp
        next if line.empty?

        result = evaluate(line)
        puts result
      rescue StandardError => e
        puts "Error: #{e.message}"
      end
    rescue Interrupt
      puts "\nBye!"
    end

    private

    def run_source(source)
      scanner = Rlox::Scanner.new(source)
      tokens = scanner.scan_tokens
      parser = Rlox::Parser.new(tokens)
      expression = parser.parse

      printer = Rlox::AstPrinter.new
      printer.print(expression)
    end

    def evaluate(source)
      scanner = Rlox::Scanner.new(source)
      tokens = scanner.scan_tokens
      parser = Rlox::Parser.new(tokens)
      expressions = parser.parse

      return if expressions.nil?

      interpreter = Rlox::Interpreter.new
      interpreter.evaluate(expressions.first)
    end
  end
end
