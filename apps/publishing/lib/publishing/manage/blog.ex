defmodule Publishing.Manage.Blog do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @optional_fields ~w(fullname username bio donate_url avatar_url platform_id)a
  @required_fields ~w()a

  schema "blog" do
    field :fullname, :string
    field :username, :string
    field :bio, :string
    field :donate_url, :string
    field :avatar_url, :string

    belongs_to :platform, Publishing.Manage.Platform
    has_many :articles, Publishing.Manage.Article

    timestamps()
  end

  def changeset(%__MODULE__{} = struct, %{} = attrs) do
    struct
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:fullname, max: 255)
    |> validate_length(:username, max: 255)
    |> validate_length(:bio, max: 255)
  end
end
