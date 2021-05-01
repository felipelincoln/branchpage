defmodule Publishing.Manage.Article do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @optional_fields ~w(title edit_url blog_id)a
  @required_fields ~w()a

  schema "article" do
    field :title, :string
    field :edit_url, :string
    field :body, :string, virtual: true

    belongs_to :blog, Publishing.Manage.Blog, type: :binary_id

    timestamps()
  end

  def changeset(%__MODULE__{} = struct, %{} = attrs) do
    struct
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:title, max: 255)
    |> assoc_constraint(:blog)
    |> unique_constraint(:edit_url)
  end
end
