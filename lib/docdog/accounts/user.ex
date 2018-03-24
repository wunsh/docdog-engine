defmodule Docdog.Accounts.User do
  @moduledoc """
    The User representation.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Docdog.Accounts.User

  schema "users" do
    field(:email, :string)
    field(:username, :string)
    field(:avatar, :string)
    field(:admin, :boolean, default: false)

    timestamps()

    has_many(:projects, Docdog.Editor.Project, on_delete: :nilify_all)
    has_many(:documents, Docdog.Editor.Document, on_delete: :nilify_all)
    has_many(:lines, Docdog.Editor.Line, on_delete: :nilify_all)
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username, :avatar])
    |> validate_required([:email, :username])
  end

  def basic_info(auth) do
    %{
      email: auth.info.email,
      username: name_from_auth(auth),
      avatar: auth.info.image
    }
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name_parts =
        [auth.info.first_name, auth.info.last_name]
        |> Enum.filter(&(&1 != nil and &1 != ""))

      if name_parts == [] do
        auth.info.nickname
      else
        Enum.join(name_parts, " ")
      end
    end
  end
end
