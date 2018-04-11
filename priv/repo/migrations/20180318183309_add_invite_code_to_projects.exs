defmodule Docdog.Repo.Migrations.AddInviteCodeToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add(
        :invite_code,
        :uuid,
        null: false,
        default: fragment("uuid_generate_v4()")
      )
    end

    create(index(:projects, [:invite_code], unique: true))
  end
end
