defmodule Publishing.Helper do
  @moduledoc """
  Helpers for the publishing application.
  """

  @doc """
  Formats a datetime into "Month. day" format
  """
  def format_date(today \\ Date.utc_today(), datetime) do
    this_day = today.day
    this_year = today.year
    yesterday = Date.add(today, -1).day
    past_year = today.year - 1

    case datetime do
      %{day: ^this_day} ->
        "Today"

      %{day: ^yesterday} ->
        "Yesterday"

      %{year: ^this_year} ->
        Timex.format!(datetime, "%b %e", :strftime)

      %{year: ^past_year} ->
        "A year ago"

      %{year: year} ->
        years_ago = this_year - year
        "#{years_ago} years ago"

      _ ->
        ""
    end
  end
end
