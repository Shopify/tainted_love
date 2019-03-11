# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceActiveRecord < Base
      def should_replace?
        Object.const_defined?('ActiveRecord')
      end

      def replace!
        require 'active_record/relation'

        TaintedLove.proxy_method(ActiveRecord::QueryMethods, :where) do |_, *args|
          unless args.empty?
            f = args.first
            if f.is_a?(String) && f.tainted?
              TaintedLove.report(:ReplaceActiveRecord, f)
            end
          end
        end

        TaintedLove.proxy_method(ActiveRecord::QueryMethods, :select) do |_, *args|
          unless args.empty?
            f = args.first
            if f.is_a?(String) && f.tainted?
              TaintedLove.report(:ReplaceActiveRecord, f)
            end
          end
        end
      end
    end
  end
end
