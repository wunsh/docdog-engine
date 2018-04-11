defmodule Docdog.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:email, :string)
      add(:avatar, :string)
    end

    create(index(:users, [:email], unique: true))
  end
end
