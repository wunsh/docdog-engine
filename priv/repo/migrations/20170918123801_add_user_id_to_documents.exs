defmodule Docdog.Repo.Migrations.AddUserIdToDocuments do
  use Ecto.Migration

  def change do
    alter table(:documents) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:documents, [:user_id])
  end
end
