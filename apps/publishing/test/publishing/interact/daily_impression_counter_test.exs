defmodule Publishing.Interact.DailyImpressionCounterTest do
  use Publishing.DataCase, async: true

  import Publishing.ChangesetHelpers
  alias Publishing.Factory
  alias Publishing.Interact.DailyImpressionCounter

  @invalid_cast_attrs %{count: "hum", article_id: 1}

  setup do
    article = Factory.insert(:article)

    valid_empty_attrs = %{article_id: article.id}
    valid_attrs = %{article_id: article.id, count: 10}

    %{valid_empty_attrs: valid_empty_attrs, valid_attrs: valid_attrs}
  end

  describe "changeset/2" do
    test "valid empty params", %{valid_empty_attrs: valid_empty_attrs} do
      changeset = DailyImpressionCounter.changeset(%DailyImpressionCounter{}, valid_empty_attrs)
      assert changeset.valid?
    end

    test "valid params", %{valid_attrs: valid_attrs} do
      changeset = DailyImpressionCounter.changeset(%DailyImpressionCounter{}, valid_attrs)
      assert changeset.valid?
    end

    test "invalid cast params" do
      changeset = DailyImpressionCounter.changeset(%DailyImpressionCounter{}, @invalid_cast_attrs)
      refute changeset.valid?

      assert %{count: [:cast]} = errors_on(changeset)
      assert %{article_id: [:cast]} = errors_on(changeset)
    end

    test "invalid required params" do
      changeset = DailyImpressionCounter.changeset(%DailyImpressionCounter{}, %{})
      refute changeset.valid?

      assert %{article_id: [:required]} = errors_on(changeset)
    end
  end
end
