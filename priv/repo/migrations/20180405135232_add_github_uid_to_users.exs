defmodule Docdog.Repo.Migrations.AddGithubUidToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :github_uid, :string
    end

    create index(:users, [:github_uid], unique: true)
  end
end
