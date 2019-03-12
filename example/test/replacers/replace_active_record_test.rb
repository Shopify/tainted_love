require 'test_helper'

class ReplaceActiveRecordTest < ActiveSupport::TestCase
  test "replaces where" do
    assert_report do
      Product.where("query".taint)
      Product.where("query")
    end
  end

  test "replaces select" do
    assert_report do
      Product.select("query".taint)
      Product.select("query")
    end
  end
end
