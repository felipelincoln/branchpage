defmodule Publishing.HelperTest do
  use ExUnit.Case, async: true

  alias Publishing.Helper

  test "format_date/2 returns a string from a Date.t()" do
    today = Date.utc_today()
    yesterday = Date.add(today, -1)
    june_first = %{today | day: 1, month: 6}
    past_year = %{today | year: today.year - 1}
    ten_years_ago = %{today | year: today.year - 10}

    assert Helper.format_date(today, today: today) == "Today"
    assert Helper.format_date(yesterday, today: today) == "Yesterday"
    assert Helper.format_date(june_first, today: today) == "Jun  1"
    assert Helper.format_date(past_year, today: today) == "A year ago"
    assert Helper.format_date(ten_years_ago, today: today) == "10 years ago"
    assert Helper.format_date(nil) == ""
    assert Helper.format_date(~D[2021-01-01], full: true) == "January  1, 2021 - 00:00"
  end
end
