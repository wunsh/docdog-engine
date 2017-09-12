defmodule Docdog.Repo.Migrations.CreateLines do
  use Ecto.Migration

  def change do
    create table(:lines) do
      add :original_text, :text
      add :translated_text, :text
      add :document_id, references(:documents, on_delete: :nothing)
      add :index_number, :integer

      timestamps()
    end

    create index(:lines, [:document_id])
  end
end
