# frozen_string_literal: true

module TaintedLove
  module Replacer
    class ReplaceDigest < Base
      def should_replace?
        Object.const_defined?('Digest')
      end

      def replace!
        digests = [:MD5, :SHA256, :SHA512, :SHA2, :SHA384, :SHA1]

        digests.each do |digest|
          mod = Digest.const_get(digest)
          mod.extend(create_module(mod)) if Object.const_defined?(mod.to_s)
        end
      end

      def create_module(digest_class)
        module_code = %{
        Module.new do
          def hexdigest(value)
            digest = super

            digest.instance_eval do
              def tainted_love_origin
                #{digest_class}
              end
            end

            digest
          end
        end
}
        eval(module_code)
      end
    end
  end
end
