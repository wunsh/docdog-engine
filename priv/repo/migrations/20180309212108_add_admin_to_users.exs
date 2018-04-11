defmodule Docdog.Repo.Migrations.AddAdminToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:admin, :boolean, default: false, null: false)
    end

    create(index(:users, [:admin]))
  end
end
