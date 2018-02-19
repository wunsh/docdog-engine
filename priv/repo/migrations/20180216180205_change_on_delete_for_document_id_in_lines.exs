defmodule Docdog.Repo.Migrations.ChangeOnDeleteForDocumentIdInLines do
  use Ecto.Migration

  def up do
    drop constraint(:lines, "lines_document_id_fkey")
    alter table(:lines) do
      modify :document_id, references(:documents, on_delete: :delete_all)
    end
  end

  def down do
    drop constraint(:lines, "lines_document_id_fkey")
    alter table(:lines) do
      modify :document_id, references(:documents, on_delete: :nothing)
    end
  end
end
