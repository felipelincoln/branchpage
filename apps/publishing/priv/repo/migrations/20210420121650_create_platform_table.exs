defmodule Publishing.Repo.Migrations.CreatePlatformTable do
  use Ecto.Migration

  def change do
    create table(:platform) do
      add :name, :string
    end

    create index(:platform, :name)
  end
end
