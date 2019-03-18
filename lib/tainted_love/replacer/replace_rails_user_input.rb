# frozen_string_literal: true
# frozen_string_literal: true

module TaintedLove
  module Replacer
    # Ensures user input is tainted in Rails
    class ReplaceRailsUserInput < Base
      def should_replace?
        Object.const_defined?('Rails')
      end

      def replace!
        # taint headers
        TaintedLove.proxy_method(ActionDispatch::Http::Headers, :[]) do |return_value, *_args|
          return_value.taint
        end

        # taint the values loaded from the database
        ActiveRecord::Base.after_find do
          attributes.values.map(&:taint)
        end

        ActionController::Base.class_eval do
          before_action :taint_params
          before_action :taint_cookies


          private
          def taint_params(value = params)
            if value.is_a?(ActionController::Parameters) || value.is_a?(ActiveSupport::HashWithIndifferentAccess)
              value.values.map(&:taint)
              value.values.each { |x| taint_params(x) }
            else
              value.taint
            end
          end

          def taint_cookies
            request.cookies.values.each(&:taint)
          end
        end

        # taint params keys
        ActionController::Parameters.class_eval do
          def keys
            @parameters.keys.map { |key| key.dup.taint }
          end
        end
      end
    end
  end
end
