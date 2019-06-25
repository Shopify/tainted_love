class ExampleSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
