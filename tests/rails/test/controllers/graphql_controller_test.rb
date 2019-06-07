# frozen_string_literal: true

require 'test_helper'

class GraphQLControllerTest < ActionDispatch::IntegrationTest
  test "string arguments are tainted" do
    response = run_graphql('{ stringArgumentTaintTestCase(input:"asdf") }')

    assert_equal({ "data" => { "stringArgumentTaintTestCase" => true } }, response)
  end

  test "string in object arguments are tainted" do
    response = run_graphql('{ objectArgumentTaintTestCase(input: { topLevelString: "Asdf" }) }')

    assert_equal({ "data" => { "objectArgumentTaintTestCase" => true } }, response)
  end

  def run_graphql(query)
    params = {
      query: query
    }

    post graphql_url, params: params
    assert_response :success

    response.parsed_body
  end
end
