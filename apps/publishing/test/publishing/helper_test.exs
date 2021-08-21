defmodule Publishing.HelperTest do
  use ExUnit.Case, async: true

  alias Publishing.Helper

  test "format_date/2 returns a string from a Date.t()" do
    today = Date.utc_today()
    yesterday = Date.add(today, -1)
    june_first = %{today | day: 1, month: 6}
    past_year = %{today | year: today.year - 1}
    ten_years_ago = %{today | year: today.year - 10}

    assert Helper.format_date(today, today) == "Today"
    assert Helper.format_date(today, yesterday) == "Yesterday"
    assert Helper.format_date(today, june_first) == "Jun  1"
    assert Helper.format_date(today, past_year) == "A year ago"
    assert Helper.format_date(today, ten_years_ago) == "10 years ago"
    assert Helper.format_date(today, nil) == ""
  end
end
