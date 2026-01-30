# frozen_string_literal: true
# typed: true

module Rlox
  # Scanner class for Lox
  class Scanner
    KEYWORDS = {
      "and" => :AND,
      "class" => :CLASS,
      "else" => :ELSE,
      "false" => :FALSE,
      "for" => :FOR,
      "fun" => :FUN,
      "if" => :IF,
      "nil" => :NIL,
      "or" => :OR,
      "print" => :PRINT,
      "return" => :RETURN,
      "super" => :SUPER,
      "this" => :THIS,
      "true" => :TRUE,
      "var" => :VAR,
      "while" => :WHILE,
    }.freeze

    #: (String source) -> void
    def initialize(source)
      @source = source
      @tokens = []
      @start = 0
      @current = 0
      @line = 1
    end

    #: -> Array[Token]
    def scan_tokens
      until at_end?
        @start = @current
        scan_token
      end

      @tokens << Token.new(:EOF, "", nil, @line)

      @tokens
    end

    private

    #: -> void
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
      when "=" then match?("=") ? add_token(:EQUAL_EQUAL) : add_token(:EQUAL)
      when "!" then match?("=") ? add_token(:NOT_EQUAL) : add_token(:BANG)
      when "<" then match?("=") ? add_token(:LESS_EQUAL) : add_token(:LESS)
      when ">" then match?("=") ? add_token(:GREATER_EQUAL) : add_token(:GREATER)
      when "/" then match?("/") ? comment_token : add_token(:SLASH)
      when '"' then string_literal
      when /\d/ then number_literal
      when /\w/ then identifier
      end
    end

    #: -> String
    def advance
      c = @source[@current]
      @current += 1
      c #: as !nil
    end

    #: -> bool
    def at_end? = @current >= @source.length

    #: -> String
    def peek
      @source[@current] #: as !nil
    end

    #: -> String
    def peek_next
      @source[@current + 1] #: as !nil
    end

    #: (String c) -> bool
    def match?(c)
      return false if at_end?
      return false if peek != c

      advance

      true
    end

    #: (Symbol type) -> void
    def add_token(type)
      text = @source[@start..(@current - 1)]
      @tokens << Token.new(type, text, nil, @line)
    end

    #: -> void
    def comment_token
      advance while peek != "\n" && !at_end?

      add_token(:COMMENT)
    end

    #: -> void
    def string_literal
      advance while peek != '"' && !at_end?

      advance # Consume closing "

      text = @source[(@start + 1)..(@current - 2)]
      @tokens << Token.new(:STRING, @source[@start..(@current - 1)], text, @line)
    end

    #: -> void
    def number_literal
      advance while peek&.match?(/\d/)

      if peek == "." && peek_next.match?(/\d/)
        advance
        advance while peek&.match?(/\d/)
      end

      text = @source[@start..(@current - 1)]
      @tokens << Token.new(:NUMBER, text, text.to_f, @line)
    end

    #: -> void
    def identifier
      advance while peek.match?(/\w/)

      text = @source[@start..(@current - 1)]
      type = KEYWORDS[text] || :IDENTIFIER
      @tokens << Token.new(type, text, nil, @line)
    end
  end
end
