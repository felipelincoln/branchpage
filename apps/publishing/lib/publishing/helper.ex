defmodule Publishing.Helper do
  @moduledoc """
  Helpers for the publishing application.
  """

  @current_year Date.utc_today().year
  @last_year @current_year - 1

  @doc """
  Formats a datetime into "Month. day" format

  Examples
      iex> format_date(~D[2021-06-15])
      "Jun 15"

      iex> format_date(~D[2020-06-21])
      "Last year"

      iex> format_date(~D[2019-12-12])
      "2 years ago"
  """
  def format_date(%{year: @current_year} = datetime) do
    Timex.format!(datetime, "%b %e", :strftime)
  end

  def format_date(%{year: @last_year}) do
    "Last year"
  end

  def format_date(%{year: year}) do
    n = @current_year - year
    "#{n} years ago"
  end

  def format_date(_), do: ""
end
