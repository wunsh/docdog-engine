defmodule Docdog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Docdog.Accounts.User

  schema "users" do
    field :username, :string

    timestamps()

    has_many :projects, Docdog.Editor.Project
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
  end

  def basic_info(auth) do
    %{username: name_from_auth(auth)} # , avatar: auth.info.image
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
             |> Enum.filter(&(&1 != nil and &1 != ""))

      cond do
        length(name) == 0 -> auth.info.nickname
        true -> Enum.join(name, " ")
      end
    end
  end
end
