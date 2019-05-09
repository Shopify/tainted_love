# frozen_string_literal: true

module TaintedLove
  module Validator
    class WebpackerYaml < Base
      def remove?(warning)
        return unless warning.replacer == :ReplaceYAML

        file = warning.stack_trace.lines.first[:file]
        if file['/lib/webpacker/env.rb'] || file['/lib/webpacker/configuration.rb']
          return true
        end
      end
    end
  end
end
