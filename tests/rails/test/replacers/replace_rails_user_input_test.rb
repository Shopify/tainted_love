# frozen_string_literal: true

require 'test_helper'

class ReplaceRailsUserInput < ActiveSupport::TestCase
  test "tainted_love_tags are copied to html_safe string" do
    tag = { source: 'something' }
    input = TaintedLove.tag('user input', tag)
    input_safe = input.html_safe

    assert_equal([tag], input_safe.tainted_love_tags)
  end
end
