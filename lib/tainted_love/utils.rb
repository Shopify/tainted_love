# frozen_string_literal: true

require 'digest/md5'

module TaintedLove
  module Utils
    # Replaces a method defined in klass. If =replace_return_value= is true,
    # the method will return what the given block returns.
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
    def add_tracking(object, payload = {}, &block)
      frozen = object.frozen?

      return if frozen && block.nil?

      payload[:stacktrace] = StackTrace.current

      object = object.dup if frozen

      object.tainted_love_tracking << payload

      block.call(object) if frozen

      object
    end

    def hash(str)
      h = Digest::MD5.new
      h.update(str)
      h.hexdigest
    end
  end
end
