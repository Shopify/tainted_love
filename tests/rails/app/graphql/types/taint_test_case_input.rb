# frozen_string_literal: true

module Types
  class TaintTestCaseInput < Types::BaseInputObject
    argument :top_level_string, String, required: true
    argument :default_value_untainted, String, required: false, default_value: "A value"
  end
end
