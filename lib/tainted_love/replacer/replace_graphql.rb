# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceGraphQL < Base
      def should_replace?
        Gem.loaded_specs.has_key?('graphql')
      end

      def replace!
        require 'graphql'

        GraphQL::Query::Arguments::ArgumentValue.class_eval do
          def value
            return @value if default_used?

            @tainted_value ||= @value.dup.taint

            TaintedLove.tag(@tainted_value, { source: "GraphQL input #{key}" })

            @tainted_value
          end
        end
      end
    end
  end
end
