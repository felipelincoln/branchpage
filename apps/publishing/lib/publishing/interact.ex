defmodule Publishing.Interact do
  @moduledoc """
  Interact's public API.
  """

  alias Publishing.Interact.DailyImpressionCounter
  alias Publishing.Repo

  import Ecto.Query

  @doc """
  Returns the sum of all daily impression counter.
  """
  @spec impressions_total(struct) :: struct
  def impressions_total(article) do
    DailyImpressionCounter
    |> from()
    |> where(article_id: ^article.id)
    |> select([d], sum(d.count))
    |> Repo.one()
    |> Kernel.||(0)
  end

  def impressions_today(article) do
    impressions_by_date(article, Date.utc_today())
  end

  def impressions_by_date(article, date) do
    DailyImpressionCounter
    |> from()
    |> where(article_id: ^article.id)
    |> where(day: ^date)
    |> select([d], d.count)
    |> Repo.one()
    |> Kernel.||(0)
  end

  def user_impressions_by_date(user_id, date) do
    from(
      d in DailyImpressionCounter,
      join: a in assoc(d, :article),
      on: a.blog_id == ^user_id,
      where: d.day == ^date,
      select: sum(d.count)
    )
    |> Repo.one()
    |> Kernel.||(0)
  end

  def put_impressions(article) do
    total = impressions_total(article)
    today = impressions_today(article)

    article
    |> Map.put(:impressions_total, total)
    |> Map.put(:impressions_today, today)
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
