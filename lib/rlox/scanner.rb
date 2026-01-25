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

    def scan_token
      c = advance

      case c
      when "(" then add_token(:LEFT_PAREN)
      when ")" then add_token(:RIGHT_PAREN)
      when "[" then add_token(:LEFT_BRACKET)
      when "]" then add_token(:RIGHT_BRACKET)
      when "{" then add_token(:LEFT_CURLY_BRACE)
      when "}" then add_token(:RIGHT_CURLY_BRACE)
      when "+" then add_token(:PLUS)
      when "-" then add_token(:MINUS)
      when "*" then add_token(:STAR)
      when ";" then add_token(:SEMICOLON)
      when "=" then match("=") ? add_token(:EQUAL_EQUAL) : add_token(:EQUAL)
      when "!" then match("=") ? add_token(:NOT_EQUAL) : add_token(:BANG)
      when "<" then match("=") ? add_token(:LESS_EQUAL) : add_token(:LESS)
      when ">" then match("=") ? add_token(:GREATER_EQUAL) : add_token(:GREATER)
      when "/" then match("/") ? comment_token : add_token(:SLASH)
      when '"' then string_literal
      when /\d/ then number_literal
      when /\w/ then identifier
      end
    end

    def advance
      c = @source[@current]
      @current += 1
      c
    end

    def at_end? = @current >= @source.length

    def peek = @source[@current]
    def peek_next = @source[@current + 1]

    def match(c)
      return false if at_end?
      return false if peek != c

      advance

      true
    end

    def add_token(type)
      text = @source[@start..@current - 1]
      @tokens << Token.new(type, text, nil, @line)
    end

    def comment_token
      advance while peek != "\n" && !at_end?

      add_token(:COMMENT)
    end

    def string_literal
      advance while peek != '"' && !at_end?

      advance # Consume closing "

      text = @source[@start + 1..@current - 2]
      @tokens << Token.new(:STRING, @source[@start..@current - 1], text, @line)
    end

    def number_literal
      advance while peek&.match?(/\d/)

      if peek == "." && peek_next&.match?(/\d/)
        advance
        advance while peek&.match?(/\d/)
      end

      text = @source[@start..@current - 1]
      @tokens << Token.new(:NUMBER, text, text.to_f, @line)
    end

    def identifier
      advance while peek&.match?(/\w/)

      text = @source[@start..@current - 1]
      @tokens << Token.new(:IDENTIFIER, text, nil, @line)
    end
  end
end
