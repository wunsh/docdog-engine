defmodule Docdog.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Docdog.Accounts.User

  schema "users" do
    field :email, :string
    field :username, :string
    field :avatar, :string

    timestamps()

    has_many :projects, Docdog.Editor.Project
    has_many :documents, Docdog.Editor.Document
    has_many :lines, Docdog.Editor.Line
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username, :avatar])
    |> validate_required([:email, :username])
  end

  def basic_info(auth) do
    %{ email: auth.info.email, username: name_from_auth(auth), avatar: auth.info.image }
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
