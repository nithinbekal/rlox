# frozen_string_literal: true
# typed: true

module Rlox
  class Environment
    #: -> void
    def initialize
      @values = {}
    end

    #: (Token name, Object value) -> void
    def assign(name, value)
      raise "Undefined variable '#{name}'." unless @values.key?(name)

      @values[name] = value
    end

    #: (String name, Object value) -> void
    def define(name, value)
      @values[name] = value
    end

    #: (String name) -> Object
    def get(name)
      return @values[name] if @values.key?(name)

      raise "Undefined variable '#{name}'."
    end
  end
end
