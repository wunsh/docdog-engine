defmodule Docdog.Repo.Migrations.AddDescriptionToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add(:description, :string)
    end
  end
end
