defmodule Publishing.Manage.Article do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @optional_fields ~w(cover blog_id)a
  @required_fields ~w(title description url)a

  schema "article" do
    field :title, :string
    field :url, :string
    field :description, :string
    field :cover, :string
    field :body, :string, virtual: true
    field :impressions_total, :integer, virtual: true
    field :impressions_today, :integer, virtual: true

    belongs_to :blog, Publishing.Manage.Blog, type: :binary_id

    timestamps()
  end

  def changeset(%__MODULE__{} = struct, %{} = attrs) do
    struct
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:title, max: 255)
    |> validate_length(:description, max: 255)
    |> assoc_constraint(:blog)
    |> unique_constraint(:url)
  end

  @doc """
  Prints a message relative to the first error in the `changeset`.
  """
  def get_error(%Ecto.Changeset{errors: [{:url, _reason} | _tail]}) do
    "This article has already been published."
  end

  def get_error(%Ecto.Changeset{errors: [{field, reason} | _tail]}) do
    {msg, opts} = reason

    error_msg =
      Enum.reduce(opts, msg, fn {key, value}, msg ->
        String.replace(msg, "%{#{key}}", to_string(value))
      end)

    field_str =
      field
      |> to_string()
      |> String.capitalize()

    field_str <> " " <> error_msg
  end
end
