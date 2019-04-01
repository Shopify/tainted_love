# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceFile < Base
      def replace!
        File.instance_eval do
          alias :_tainted_love_original_read :read
        end

        File.instance_eval do
          def read(*args)
            if args.first.tainted?
              TaintedLove.report(:ReplaceFile, args.first)

              _tainted_love_original_read(*args)
            else
              _tainted_love_original_read(*args).untaint
            end
          end
        end

      end
    end
  end
end
