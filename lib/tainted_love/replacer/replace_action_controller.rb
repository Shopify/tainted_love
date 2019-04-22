# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceActionController < Base
      def should_replace?
        Object.const_defined?('ActionController')
      end

      def replace!
        TaintedLove.proxy_method('ActionController::Instrumentation', :send_file) do |_, *args|
          TaintedLove.report(
            :ReplaceActionController,
            args.first,
            [:lfi],
            'Sendfile using tainted file name'
          ) if args.first.tainted?
        end

        TaintedLove.proxy_method('ActionController::Instrumentation', :render) do |_, *args|
          unless args.empty?
            f = args.first

            if f.is_a?(Hash)
              if f.key?(:inline) && f[:inline].tainted?
                TaintedLove.report(
                  :ReplaceActionController,
                  f[:inline],
                  [:rce],
                  'render(inline:) using tainted string'
                )
              end

              if f.key?(:file) && f[:file].tainted?
                TaintedLove.report(
                  :ReplaceActionController,
                  f[:file],
                  [:lfi],
                  'render(file:) using tainted file name'
                )
              end
            end

            if f.is_a?(String) && f.tainted?
              TaintedLove.report(
                :ReplaceActionController,
                f,
                [:lfi],
                'render using tainted template name'
              )
            end
          end
        end

        TaintedLove.proxy_method('ActionController::Base', :redirect_to) do |_, *args|
          TaintedLove.report(:ReplaceActionController, args.first, [:open_redirect]) if args.first.tainted?
        end
      end
    end
  end
end
