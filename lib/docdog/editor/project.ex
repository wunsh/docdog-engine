defmodule Docdog.Editor.Project do
  @moduledoc """
    The Project representation.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Docdog.Editor.Project

  schema "projects" do
    field(:name, :string)
    field(:public, :boolean)
    field(:completed_percentage, :decimal, virtual: true)

    timestamps()

    belongs_to(:user, Docdog.Accounts.User)

    has_many(:documents, Docdog.Editor.Document, on_delete: :delete_all)
  end

  @doc false
  def changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, [:name, :public, :user_id])
    |> validate_required([:name, :public, :user_id])
  end
end
