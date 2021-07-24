defmodule Publishing.Repo.Migrations.CreateDailyImpressionCounterTable do
  use Ecto.Migration

  def change do
    create table(:daily_impression_counter) do
      add :count, :integer
      add :day, :date, default: fragment("now()")
      add :article_id, references(:article, type: :uuid)

      timestamps()
    end
  end
end
