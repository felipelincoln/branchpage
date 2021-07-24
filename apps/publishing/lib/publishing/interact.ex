defmodule Publishing.Interact do
  @moduledoc """
  Interact's public API.
  """

  alias Publishing.Interact.DailyImpressionCounter
  alias Publishing.Repo

  import Ecto.Query

  @doc """
  Populate article's impressions field with the sum of
  all daily impression counter.
  """
  @spec put_impressions(struct) :: struct
  def put_impressions(article) do
    impressions =
      DailyImpressionCounter
      |> from()
      |> where(article_id: ^article.id)
      |> Repo.all()
      |> Enum.reduce(0, fn %{count: count}, acc -> acc + count end)

    %{article | impressions: impressions}
  end

  @doc """
  Increase article's impression counter for the current day.
  """
  @spec view(Ecto.UUID.t()) :: {:ok, DailyImpressionCounter.t()}
  def view(article_id) do
    today = Date.utc_today()

    daily_impression_count =
      Repo.get_by(DailyImpressionCounter, article_id: article_id, day: today)

    case daily_impression_count do
      nil ->
        attrs = %{article_id: article_id}

        %DailyImpressionCounter{}
        |> DailyImpressionCounter.changeset(attrs)
        |> Repo.insert()

      %DailyImpressionCounter{} ->
        attrs = %{count: daily_impression_count.count + 1}

        daily_impression_count
        |> DailyImpressionCounter.changeset(attrs)
        |> Repo.update()
    end
  end
end
