# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceRackBuilder < Base
      def should_replace?
        Object.const_defined?('Rack::Builder')
      end

      def replace!
        # Register a middleware that will be the first the receive call and prepare the
        # env to be correctly tainted. This should be enough for all Rack-based apps
        TaintedLove.proxy_method('Rack::Builder', :run) do |_, app, builder|
          builder.use(TaintedLove::Replacer::ReplaceRackRequest::TaintedLoveRackMiddleware)
        end
      end

      class TaintedLoveRackMiddleware
        def initialize(app)
          @app = app
        end

        def call(env)
          @app.call(taint_env(env))
        end

        def taint_env(env)
          uppercase_keys = env.to_h.keys.select { |k| k[/[A-Z]/] }

          values = {}
          uppercase_keys.each do |key|
            new_key = key.dup.taint
            new_value = env[key].dup.taint

            TaintedLove.tag(new_key, source: "Key #{key.inspect} Rack env")
            TaintedLove.tag(new_value, source: "Rack env[#{key.inspect}]")

            values[new_key] = new_value

            env.delete(key)
          end

          env.merge!(values)

          env
        end
      end

    end
  end
end
