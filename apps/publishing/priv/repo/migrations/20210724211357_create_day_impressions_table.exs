defmodule Publishing.Repo.Migrations.CreateDayImpressionsTable do
  use Ecto.Migration

  def change do
    create table(:day_impressions) do
      add :count, :integer
      add :day, :date, default: fragment("now()")
      add :article_id, references(:article, type: :uuid)

      timestamps()
    end
  end
end
