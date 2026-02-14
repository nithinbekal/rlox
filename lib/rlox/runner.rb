# frozen_string_literal: true
# typed: true

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
      statements = parser.parse

      interpreter = Rlox::Interpreter.new
      statements.each { |stmt| interpreter.execute(stmt) }
    end

    def evaluate(source)
      scanner = Rlox::Scanner.new(source)
      tokens = scanner.scan_tokens
      parser = Rlox::Parser.new(tokens)
      statements = parser.parse

      return if statements.empty?

      interpreter = Rlox::Interpreter.new

      statements.each do |stmt|
        if stmt.is_a?(Rlox::Expression)
          result = interpreter.evaluate(stmt.expression)
          return interpreter.send(:stringify, result)
        else
          interpreter.execute(stmt)
        end
      end

      nil
    end
  end
end
