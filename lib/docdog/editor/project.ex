defmodule Docdog.Editor.Project do
  @moduledoc """
    The Project representation.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Docdog.Editor.Project

  schema "projects" do
    field(:name, :string)
    field(:public, :boolean, default: false)
    field(:completed_percentage, :decimal, virtual: true)
    field(:members, {:array, :integer}, default: [])

    timestamps()

    belongs_to(:user, Docdog.Accounts.User)

    has_many(:documents, Docdog.Editor.Document, on_delete: :delete_all)
    has_many(:lines, Docdog.Editor.Line)
  end

  @doc false
  def changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, [:name, :public, :members, :user_id])
    |> validate_required([:name, :public, :user_id])
  end
end
