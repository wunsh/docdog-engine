defmodule Docdog.Repo.Migrations.AddMembersToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :members, {:array, :integer}, default: [], null: false
    end

    create index(:projects, [:members], using: "GIN")
  end
end
