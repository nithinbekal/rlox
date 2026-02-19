# frozen_string_literal: true
# typed: true

module Rlox
  class Environment
    #: (?enclosing: Environment?) -> void
    def initialize(enclosing: nil)
      @values = {}
      @enclosing = enclosing
    end

    #: (Token name, Object value) -> void
    def assign(name, value)
      return @values[name] = value if @values.key?(name)
      return @enclosing.assign(name, value) if @enclosing

      raise "Undefined variable '#{name}'."
    end

    #: (String name, Object value) -> void
    def define(name, value)
      @values[name] = value
    end

    #: (String name) -> Object
    def get(name)
      return @values[name] if @values.key?(name)
      @enclosing.get(name) if @enclosing

      raise "Undefined variable '#{name}'."
    end
  end
end
