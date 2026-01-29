# frozen_string_literal: true

require_relative "rlox/version"
require_relative "rlox/scanner"
require_relative "rlox/token"
require_relative "rlox/expr"
require_relative "rlox/ast_printer"
require_relative "rlox/parser"

module Rlox
  class Error < StandardError; end
  # Your code goes here...
end
