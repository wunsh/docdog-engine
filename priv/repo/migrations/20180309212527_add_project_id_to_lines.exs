defmodule Docdog.Repo.Migrations.AddProjectIdToLines do
  use Ecto.Migration

  def change do
    alter table(:lines) do
      add :project_id, references(:projects, on_delete: :nothing)
    end

    create index(:lines, [:project_id])
  end
end
