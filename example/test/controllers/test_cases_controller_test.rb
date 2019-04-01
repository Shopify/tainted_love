# frozen_string_literal: true

require 'test_helper'

class TestCasesControllerTest < ActionDispatch::IntegrationTest
  include TaintedLoveHelpers

  test "should get xss" do
    assert_report do
      get test_cases_xss_url(search: '<img src=x oenrror=alert(1)>')
    end

    assert_response :success
  end

  test "should get unsafe_render" do
    assert_report do
      get test_cases_unsafe_render_url(file: 'xss')
    end

    assert_response :success
  end

  test "should get render_inline" do
    assert_report do
      get test_cases_render_inline_url(template: '<%= `id` %>')
    end

    assert_response :success
  end

  test "should get unsafe_redirect" do
    assert_report do
      get test_cases_unsafe_redirect_url(to: 'http://evil.com')
    end

    assert_response :redirect
  end
end
