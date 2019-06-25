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
              TaintedLove.report(:ReplaceActiveRecord, f, [:sqli], 'Model.where using tainted string')
            end
          end
        end

        TaintedLove.proxy_method('ActiveRecord::QueryMethods', :select) do |_, *args|
          unless args.empty?
            f = args.first
            if f.is_a?(String) && f.tainted?
              TaintedLove.report(:ReplaceActiveRecord, f, [:sqli], 'Model#select using tainted string')
            end
          end
        end

        mod = Module.new do
          [:find_by_sql, :count_by_sql].each do |method|
            define_method(method) do |*args|
              if args.first.tainted?
                TaintedLove.report(:ReplaceActiveRecord, args.first, [:sqli], "Model##{method} using tainted string")
              end

              super(*args)
            end
          end

          # Removes taint on string have been sanitized, unless the first argument is tainted
          def sanitize_sql_array(ary)
            return_value = super(ary)

            if ary.first.tainted?
              return_value.taint
            end

            return_value
          end
        end

        ActiveRecord::Base.extend(mod)
      end
    end
  end
end
