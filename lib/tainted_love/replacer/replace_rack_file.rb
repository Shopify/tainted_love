# frozen_string_literal: true

module TaintedLove
  module Replacer

    class ReplaceRackFile < Base
      def replace!
        # Assume that Rack::File is used path that are safe
        TaintedLove::Utils::Proxy.new('Rack::File', :call) do
          def before
            env['PATH_INFO'].untaint
          end

          def env
            arguments.first
          end
        end

        TaintedLove.proxy_method('Rack::File', :initialize) do |_, *args|
          args.first.untaint
        end
      end
    end
  end
end
