# frozen_string_literal: true

module Rlox
  # Scanner class for Lox
  class Scanner
    KEYWORDS = {
      "var" => :VAR
    }.freeze

    def initialize(source)
      @source = source
      @tokens = []
      @start = 0
      @current = 0
      @line = 1
    end

    def scan_tokens
      until at_end?
        @start = @current
        scan_token
      end

      @tokens << Token.new(:EOF, "", nil, @line)

      @tokens
    end

    private

    def at_end?
      @current >= @source.length
    end

    def scan_token
      c = advance

      case c
      when "(" then add_token(:LEFT_PAREN)
      when ")" then add_token(:RIGHT_PAREN)
      when "[" then add_token(:LEFT_BRACKET)
      when "]" then add_token(:RIGHT_BRACKET)
      when "{" then add_token(:LEFT_CURLY_BRACE)
      when "}" then add_token(:RIGHT_CURLY_BRACE)
      end
    end

    def advance
      c = @source[@current]
      @current += 1
      c
    end

    def add_token(type)
      text = @source[@start..@current - 1]
      @tokens << Token.new(type, text, nil, @line)
    end
  end
end
