# frozen_string_literal: true

require 'digest/md5'

module TaintedLove
  module Utils
    # Replaces a method defined in klass.
    #
    # @param klass [Class, String] The target class
    # @param method [Symbol] The method name to replace
    # @param replace_return_value [Boolean]
    #   If true, the return value of the function will be the value returned by the block.
    #   Otherwise, the function will return its original value.
    # @yield [*args, &block] Block to execute when the function is called
    def proxy_method(klass, method, replace_return_value = false, &block)
      if klass.is_a?(String)
        if Object.const_defined?(klass)
          klass = Object.const_get(klass)
        else
          return
        end
      end

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
    # @param object [Object] Object to add tracking
    # @param payload [Hash] Data to add to the object
    # @return [Object] Given object or dup of it
    def tag(object, payload = {})
      object.tainted_love_tags << payload

      object
    end

    # Create a hex encoded MD5 hash
    #
    # @param str [String] Input string
    # @return [String]
    def hash(str)
      h = Digest::MD5.new
      h.update(str)
      h.hexdigest
    end
  end
end
