# frozen_string_literal: true

module Rlox
  Token = Data.define(:type, :lexeme, :literal, :line) do
    def to_s
      "#{type} #{lexeme} #{literal} #{line}"
    end
  end
end
