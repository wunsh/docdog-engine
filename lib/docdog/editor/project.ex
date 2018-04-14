defmodule Docdog.Editor.Project do
  @moduledoc """
    The Project representation.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Docdog.Editor.{Project, Document, Line}
  alias Docdog.Accounts.User

  schema "projects" do
    field(:name, :string)
    field(:description, :string)
    field(:public, :boolean, default: false)
    field(:completed_percentage, :decimal, virtual: true)
    field(:invite_code, Ecto.UUID)
    field(:members, {:array, :integer}, default: [])

    timestamps()

    belongs_to(:user, User)

    has_many(:documents, Document, on_delete: :delete_all)
    has_many(:lines, Line)
  end

  @doc false
  def changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, [:name, :public, :members, :user_id, :description])
    |> validate_required([:name, :public, :user_id])
  end
end
