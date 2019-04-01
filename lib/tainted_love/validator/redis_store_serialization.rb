# frozen_string_literal: true
module TaintedLove
  module Validator
    # Assumes that value unserialized from Redis are safe
    class RedisStoreSerialization < Base
      def remove?(warning)
        return warning.replacer == :ReplaceMarshal &&
               warning.stack_trace_line[:file]['redis/store/serialization.rb']
      end
    end
  end
end
