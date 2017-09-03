defmodule Docdog.Editor.Document do
  use Ecto.Schema
  import Ecto.Changeset
  alias Docdog.Editor.Document


  schema "documents" do
    field :name, :string

    timestamps()

    belongs_to :project, Docdog.Editor.Project
  end

  @doc false
  def changeset(%Document{} = document, attrs) do
    document
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
