defmodule Publishing.Manage.DailyImpressionCounter do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @optional_fields ~w(count)a
  @required_fields ~w(article_id)a

  schema "daily_impression_counter" do
    field :count, :integer
    field :day, :date

    belongs_to :article, Publishing.Manage.Article, type: :binary_id

    timestamps()
  end

  def changeset(%__MODULE__{} = struct, %{} = attrs) do
    struct
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:article)
  end
end
