module Types
  class QueryType < Types::BaseObject
    field :object_argument_taint_test_case, Boolean, null: false do
      argument :input, TaintTestCaseInput, required: true
    end

    field :string_argument_taint_test_case, Boolean, null: false do
      argument :input, String, required: true
      argument :input_default, String, required: false, default_value: "something"
    end

    field :mutate_context, Integer, null: true do
      argument :id, Integer, required: true
    end

    field :whoami, Integer, null: true

    field :products, [ProductType], null: true

    def object_argument_taint_test_case(input:)
      [
        input.top_level_string.tainted?,
        !input.default_value_untainted.tainted?
      ].all?
    end

    def string_argument_taint_test_case(input:, input_default:)
      [
        input.tainted?,
        !input_default.tainted?
      ].all?
    end

    def mutate_context(id:)
      context[:user_id] = id
    end

    def whoami
      context[:user_id]
    end

    def products
      Product.all
    end
  end
end
