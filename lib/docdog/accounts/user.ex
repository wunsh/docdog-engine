defmodule Docdog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Docdog.Accounts.User


  schema "users" do
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
  end
end
