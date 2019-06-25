require 'test_helper'

class ReplaceActiveRecordTest < ActiveSupport::TestCase
  test "replaces where" do
    assert_report do
      Product.where("query".taint)
      Product.where("query")
    end
  end

  test "reports when the interpolation string is tainted" do
    assert_report do
      Product.where("id = ?".taint, 1)
      Product.where("id = ?", 1)
    end
  end

  test "reports when using find_by" do
    assert_report do
      Product.find_by("id".taint)
      Product.find_by("id")
    end
  end

  test "doesn't report when a hash is used with find_by" do
    assert_report(0) do
      Product.find_by(id: 1)
      # Product.find_by(title: "title".taint)
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
