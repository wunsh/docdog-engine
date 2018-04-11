defmodule Docdog.Repo.Migrations.AddProcessedToLines do
  use Ecto.Migration

  def change do
    alter table(:lines) do
      add(:processed, :boolean, default: false, null: false)
    end

    create(index(:lines, [:processed]))
  end
end
