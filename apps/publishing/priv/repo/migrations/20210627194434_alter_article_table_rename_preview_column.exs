defmodule Publishing.Repo.Migrations.AlterArticleTableRenamePreviewColumn do
  use Ecto.Migration

  def change do
    rename table(:article), :preview, to: :description

    alter table(:article) do
      modify :description, :string
      add :cover, :text
    end
  end
end
