module TaintedLove
  module Replacer
    class ReplaceString < Base
      WRAP_METHODS = [
        :+, :*, :[], :[]= , :sub, :replace, :strip, :strip!, :inspect
      ]

      def replace!
        mod = Module.new do
          def self.wrap_call(name)
            define_method(name) do |*args, &block|
              return super(*args, &block) unless tainted? || args.any?(&:tainted?)

              result = super(*args, &block)

              result.tainted_love_tags += tainted_love_tags if tainted?

              args.select(&:tainted?).each do |arg|
                result.tainted_love_tags += arg.tainted_love_tags
              end

              result
            end
          end

          WRAP_METHODS.each do |sym|
            wrap_call(sym)
          end

          def gsub(*args, &block)
            # Context for this hack: https://stackoverflow.com/a/52783055/3349159

            match(args.first)

            unless block.nil?
              block.binding.tap do |b|
                b.local_variable_set(:_tainted_love_tilde_variable, $~)
                b.eval("$~ = _tainted_love_tilde_variable")
              end
            end

            super(*args, &block)
          end

          def split(*args)
            result = super(*args)

            if tainted?
              result.each do |value|
                value.taint.tainted_love_tags += tainted_love_tags
              end
            end

            result
          end
        end

        String.prepend(mod)
      end
    end
  end
end
