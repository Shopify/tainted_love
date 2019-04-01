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

  test "replaces find_by_sql" do
    assert_report do
      Product.find_by_sql("select * from products".taint)
      Product.find_by_sql("select * from products")
    end
  end

  test "replaces count_by_sql" do
    assert_report do
      Product.count_by_sql("select * from products".taint)
      Product.count_by_sql("select * from products")
    end
  end

end
