defmodule Docdog.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add(:name, :string)
      add(:original_text, :text)
      add(:project_id, references(:projects, on_delete: :nothing))

      timestamps()
    end

    create(index(:documents, [:project_id]))
  end
end
