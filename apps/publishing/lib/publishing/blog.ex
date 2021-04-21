defmodule Publishing.Blog do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @optional_fields ~w(fullname username bio donate_url)a
  @required_fields ~w()a

  schema "blog" do
    field(:fullname, :string)
    field(:username, :string)
    field(:bio, :string)
    field(:donate_url, :string)

    has_many(:articles, Publishing.Article)

    timestamps()
  end

  def changeset(%__MODULE__{} = struct, %{} = attrs) do
    struct
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
