defmodule Docdog.Repo.Migrations.AddUserIdToLines do
  use Ecto.Migration

  def change do
    alter table(:lines) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:lines, [:user_id])
  end
end
