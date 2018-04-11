defmodule Docdog.Repo.Migrations.AddPublicToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add(:public, :boolean, default: false, null: false)
    end

    create(index(:projects, [:public]))
  end
end
