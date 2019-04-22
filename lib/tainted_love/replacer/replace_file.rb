# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceFile < Base
      def replace!
        File.instance_eval do
          alias :_tainted_love_original_read :read
          alias :_tainted_love_original_write :write

          def read(*args)
            if args.first.tainted?
              TaintedLove.report(:ReplaceFile, args.first, [:lfi], 'File read using tainted file name')

              _tainted_love_original_read(*args)
            else
              _tainted_love_original_read(*args).untaint
            end
          end

          def write(*args)
            if args.first.tainted?
              TaintedLove.report(:ReplaceFile, args.first, [:lfi], 'File write using tainted file name')
            end

            _tainted_love_original_write(*args)
          end
        end
      end
    end
  end
end
