# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceActiveRecord < Base
      def should_replace?
        Object.const_defined?('ActiveRecord')
      end

      def replace!
        require 'active_record/relation'

        TaintedLove.proxy_method('ActiveRecord::QueryMethods', :where) do |_, *args|
          unless args.empty?
            f = args.first
            if f.is_a?(String) && f.tainted?
              TaintedLove.report(:ReplaceActiveRecord, f)
            end
          end
        end

        TaintedLove.proxy_method('ActiveRecord::QueryMethods', :select) do |_, *args|
          unless args.empty?
            f = args.first
            if f.is_a?(String) && f.tainted?
              TaintedLove.report(:ReplaceActiveRecord, f)
            end
          end
        end

        mod = Module.new do
          [:find_by_sql, :count_by_sql].each do |method|
            define_method(method) do |*args|
              if args.first.tainted?
                TaintedLove.report(:ReplaceActiveRecord, args.first)
              end

              super(*args)
            end
          end
        end

        ActiveRecord::Base.extend(mod)
      end
    end
  end
end
