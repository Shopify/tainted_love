# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceRackRequest < Base

      def replace!
        block = method(:taint_params)

        TaintedLove.proxy_method('Rack::QueryParser', :parse_nested_query, &block)
        TaintedLove.proxy_method('Rack::QueryParser', :parse_query, &block)
      end

      def taint_params(return_value, *args)
        # Assume that if tainted input uses this method, it's to parse a query string
        return unless args.first.tainted?

        taint = lambda do |params, path|
          source = "params" + path.map { |p| "[#{p.inspect}]" }.join

          if params.is_a?(String)
            TaintedLove.tag(params.taint, source: source)
          end

          if params.is_a?(Array)
            params.each.with_index do |value, index|
              taint.(value, path + [index])
            end
          end

          if params.is_a?(Hash)
            params.each do |key, value|
              taint.(value, path + [key])
            end
          end
        end

        taint.(return_value, [])
      end
    end
  end
end
