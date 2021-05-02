defmodule Publishing.Repo.Migrations.CreateArticleTable do
  use Ecto.Migration

  def change do
    create table(:article, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :title, :string
      add :url, :text
      add :blog_id, references(:blog, type: :uuid)

      timestamps()
    end

    create unique_index(:article, :url)
  end
end
