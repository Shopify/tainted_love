# frozen_string_literal: true

module TaintedLove
  module Replacer
    # Ensures user input is tainted in Rails
    class ReplaceRailsUserInput < Base
      def should_replace?
        Object.const_defined?('Rails')
      end

      def replace!

        TaintedLove.proxy_method('ActionDispatch::Http::Headers', :[]) do |return_value, *_args|
          return_value.taint
        end

        # taint the values loaded from the database
        if Object.const_defined?('ActiveRecord::Base')
          ActiveRecord::Base.after_find do
            attributes.values.each do |value|
              unless value.frozen?
                TaintedLove.tag(value.taint)
              end
            end
          end
        end

        # taint params keys
        if Object.const_defined?('ActionController::Parameters')
          ActionController::Parameters.class_eval do
            def keys
              @parameters.keys.map { |key|
                TaintedLove.tag(key.dup.taint, source: "Parameter name #{key.inspect}")
              }
            end
          end
        end

        TaintedLove.proxy_method('ActiveSupport::SafeBuffer', :initialize) do |return_value, str|
          return_value.tainted_love_tags = str.tainted_love_tags
        end
      end
    end
  end
end
