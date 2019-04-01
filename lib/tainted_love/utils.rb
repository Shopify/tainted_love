# frozen_string_literal: true

require 'digest/md5'

module TaintedLove
  module Utils
    # Replaces a method defined in klass.
    #
    #
    # @param klass [Class] The target class
    # @param method [Symbol] The method name to replace
    # @param replace_return_value [Boolean]
    #   If true, the return value of the function will be the value returned by the block.
    #   Otherwise, the function will return its original value.
    # @yield [*args, &block] Block to execute when the function is called
    def proxy_method(klass, method, replace_return_value = false, &block)
      original_method = "_tainted_love_original_#{method}"

      klass.class_eval do
        alias_method original_method, method

        define_method method do |*args, &given_block|
          return_value = send(original_method, *args, &given_block)

          block_return = block.call(return_value, *args, self, &block)

          if replace_return_value
            block_return
          else
            return_value
          end
        end
      end
    end

    # Adds information about the object. The information can be about
    # where the object is coming from, validation that has been done on the object, etc.
    #
    # If the object is frozen, the given block will be called with a new object.
    # The caller has the responsability of replacing the frozen object with this
    # new object.
    #
    # @param object [Object] Object to add tracking
    # @param payload [Hash] Data to add to the object
    # @yield [Object] Invoked with a duplicate unfrozen version of object
    # @return [Object] Given object or dup of it
    def add_tracking(object, payload = {}, &block)
      frozen = object.frozen?

      return if frozen && block.nil?

      payload[:stacktrace] = StackTrace.current

      object = object.dup if frozen

      object.tainted_love_tracking << payload

      block.call(object) if frozen

      object
    end

    # Create a hex encoded MD5 hash
    #
    # @params str [String] Input string
    # @returns [String]
    def hash(str)
      h = Digest::MD5.new
      h.update(str)
      h.hexdigest
    end
  end
end
