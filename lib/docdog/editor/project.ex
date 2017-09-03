defmodule Docdog.Editor.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Docdog.Editor.Project


  schema "projects" do
    field :name, :string

    timestamps()

    belongs_to :user, Docdog.Accounts.User

    has_many :documents, Docdog.Editor.Document
  end

  @doc false
  def changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
