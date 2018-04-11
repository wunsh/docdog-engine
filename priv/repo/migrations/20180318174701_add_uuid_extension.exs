defmodule Docdog.Repo.Migrations.AddUuidExtension do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\" WITH SCHEMA public;")
  end

  def down do
    execute("DROP EXTENSION \"uuid-ossp\";")
  end
end
