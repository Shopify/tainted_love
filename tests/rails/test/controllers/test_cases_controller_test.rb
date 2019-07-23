# frozen_string_literal: false

require 'test_helper'

class TestCasesControllerTest < ActionDispatch::IntegrationTest
  include TaintedLoveHelpers

  test "should get xss" do
    assert_report do
      get test_cases_xss_url(search: '<img src=x oenrror=alert(1)>'.taint)
    end

    assert_response :success
  end

  test "should get unsafe_render" do
    assert_report do
      get test_cases_unsafe_render_url(file: 'xss'.taint)
    end

    assert_response :success
  end

  test "should get render_inline" do
    assert_report do
      get test_cases_render_inline_url(template: '<%= `id` %>'.taint)
    end

    assert_response :success
  end

  test "should get unsafe_redirect" do
    assert_report do
      get test_cases_unsafe_redirect_url(to: 'http://evil.com'.taint)
    end

    assert_response :redirect
  end

  test "user input is tainted" do
    # Since there's no actual app running, some values are not tainted
    # by ReplaceRackBuilder

    params = {
      get_param: 'asdf',
      get_array_param: ["abc", "def"].each(&:taint),
    }

    headers = {}
    headers['HTTP_AAA'.taint] = 'asdf'

    cookies[:something] = 'asdf'.taint

    get test_cases_taint_test_url('route_param', params: params), headers: headers

    json = JSON.parse(response.body)

    json.each do |(value_type, tainted, tags)|
      assert tainted, "#{value_type} is not tainted"
    end
  end
end
