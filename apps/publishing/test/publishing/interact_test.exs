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

    assert %{impressions_total: 635} = Interact.put_impressions(article)
  end

  test "user_impressions_by_date/2 returns all user's impressions on a date" do
    blog = Factory.insert(:blog)
    article = Factory.insert(:article, blog_id: blog.id)
    article_2 = Factory.insert(:article, blog_id: blog.id)

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

    _imp_2 =
      Factory.insert(:daily_impression_counter, %{
        article_id: article_2.id,
        count: 30,
        day: ~D[2021-01-02]
      })

    assert Interact.user_impressions_by_date(blog.id, ~D[2021-01-01]) == 100
    assert Interact.user_impressions_by_date(blog.id, ~D[2021-01-02]) == 535
    assert Interact.user_impressions_by_date(blog.id, ~D[2021-06-01]) == 0
  end

  test "user_impressions_total/1 returns all user's impressions" do
    blog = Factory.insert(:blog)
    article = Factory.insert(:article, blog_id: blog.id)
    article_2 = Factory.insert(:article, blog_id: blog.id)

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

    _imp_2 =
      Factory.insert(:daily_impression_counter, %{
        article_id: article_2.id,
        count: 30,
        day: ~D[2021-01-02]
      })

    assert Interact.user_impressions_total(blog.id) == 635
  end
end
