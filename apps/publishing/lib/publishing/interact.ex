defmodule Publishing.Interact do
  @moduledoc """
  Interact's public API.
  """

  alias Publishing.Interact.DailyImpressionCounter
  alias Publishing.Repo

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
