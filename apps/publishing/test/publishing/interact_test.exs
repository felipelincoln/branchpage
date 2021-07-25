defmodule Publishing.InteractTest do
  use Publishing.DataCase, async: true
  alias Publishing.Factory
  alias Publishing.Interact
  alias Publishing.Interact.DailyImpressionCounter

  test "view/1 creates impression data first time and updates in the next" do
    article = Factory.insert(:article)
    today = Date.utc_today()

    assert {:ok, %DailyImpressionCounter{}} = Interact.view(article.id)

    assert {:ok, %DailyImpressionCounter{count: 2, day: ^today, id: id}} =
             Interact.view(article.id)

    assert {:ok, %DailyImpressionCounter{count: 3, day: ^today, id: ^id}} =
             Interact.view(article.id)
  end

  test "put_impressions/1 returns article with impressions field populated" do
    article = Factory.insert(:article)

    _imp_1 =
      Factory.insert(:daily_impression_counter, %{
        article_id: article.id,
        count: 100,
        day: ~D[2021-01-01]
      })

    _imp_2 =
      Factory.insert(:daily_impression_counter, %{
        article_id: article.id,
        count: 505,
        day: ~D[2021-01-02]
      })

    _imp_3 =
      Factory.insert(:daily_impression_counter, %{
        article_id: article.id,
        count: 30,
        day: ~D[2020-12-12]
      })

    assert %{impressions: 635} = Interact.put_impressions(article)
  end
end
