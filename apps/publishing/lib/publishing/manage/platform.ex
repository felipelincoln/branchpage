defmodule Publishing.Manage.Platform do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @optional_fields ~w(name)a
  @required_fields ~w()a

  schema "platform" do
    field :name, :string

    has_many :blogs, Publishing.Manage.Blog
  end

  def changeset(%__MODULE__{} = struct, %{} = attrs) do
    struct
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, max: 255)
  end
end
