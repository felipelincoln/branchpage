defmodule Publishing.Repo.Migrations.CreateDailyImpressionCounterTable do
  use Ecto.Migration

  def change do
    create table(:daily_impression_counter) do
      add :count, :integer, default: 1
      add :day, :date, default: fragment("now()")
      add :article_id, references(:article, type: :uuid), null: false

      timestamps()
    end
  end
end
