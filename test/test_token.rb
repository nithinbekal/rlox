require "test_helper"

module Rlox
  class TestToken < Minitest::Test
    def test_to_s
      token = Rlox::Token.new(:STRING, '"abc"', "abc", 1)
      assert_equal 'STRING "abc" abc 1', token.to_s
    end
  end
end
