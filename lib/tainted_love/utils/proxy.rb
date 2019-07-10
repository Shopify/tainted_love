# frozen_string_literal: true
module TaintedLove
  module Utils
    # Utility to wrap a an instance function.
    #
    # @example
    #   TaintedLove::Utils::Proxy.new('MyClass', :my_method) do
    #     def before
    #       if arguments.first.tainted?
    #         @should_taint = true
    #         do_something
    #       end
    #     end
    #
    #     def around
    #       yield # calls the real method
    #     end
    #
    #     def after
    #       return_value.taint if @should_taint
    #     end
    #   end
    class Proxy
      attr_accessor :object, :return_value, :block, :arguments

      # Creates a new proxy. If klass and `method` are provided, it will invoke {#apply} with those arguments.
      #
      # @param klass [Class, String] The target class
      # @param method [Symbol] The method name to replace
      # @yield [] Evaluated the block in the context of the instance to customize the before, around and after methods
      def initialize(klass = nil, method = nil, &block)
        instance_eval(&block) unless block.nil?

        if !klass.nil? && !method.nil?
          apply(klass, method)
        end
      end

      # Invoked before invoking the original method
      def before
      end

      # Invoked after invoking the original method
      def after
      end

      # Controls the call to the original function. The default implementation of this method will yield.
      #
      # @yield [] The given block will invoke the original method
      def around
        yield
      end

      def handle(object, method, *args, &block)
        # thread safety maybe?
        @arguments = args
        @block = block
        @object = object

        before

        around do
          @return_value = object.send(method, *@arguments, &@block)
        end

        after

        @return_value
      end

      # Replaces the method in the given klass.
      #
      # @param klass [Class, String] The target class
      # @param method [Symbol] The method name to replace
      def apply(klass, method)
        if klass.is_a?(String)
          return unless Object.const_defined?(klass)

          klass = Object.const_get(klass)
        end

        proxy = self
        original_method = "_tainted_love_original_#{method}"

        klass.class_eval do
          alias_method original_method, method

          define_method method do |*args, &given_block|
            proxy.handle(self, original_method, *args, &given_block)
          end
        end
      end
    end
  end
end
