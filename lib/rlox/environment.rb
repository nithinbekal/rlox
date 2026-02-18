# frozen_string_literal: true
# typed: true

module Rlox
  class Environment
    #: -> void
    def initialize
      @values = {}
    end

    #: (String name, Object value) -> void
    def define(name, value)
      @values[name] = value
    end

    #: (String name) -> Object
    def get(name)
      return @values[name] if @values.key?(name)

      raise RuntimeError, "Undefined variable '#{name}'."
    end
  end
end
