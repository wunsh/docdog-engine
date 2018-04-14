defmodule Docdog.Editor.Document do
  @moduledoc """
    The Document representation.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Docdog.Editor
  alias Docdog.Editor.{Project, Document, Line}
  alias Docdog.Editor.Services.CreateLines
  alias Docdog.Accounts.User

  schema "documents" do
    field(:name, :string)
    field(:original_text, :string)

    timestamps()

    belongs_to(:project, Project)
    belongs_to(:user, User)

    has_many(:lines, Line, on_replace: :mark_as_invalid, on_delete: :nilify_all)
  end

  @doc false
  def changeset(%Document{} = document, attrs) do
    document
    |> cast(attrs, [:name, :original_text, :user_id, :project_id])
    |> validate_required([:name, :original_text, :user_id, :project_id])
    |> put_assoc(:lines, CreateLines.call(attrs["original_text"], attrs["project_id"]))
  end

  def translated_text(document) do
    document
    |> Editor.get_lines_for_document()
    |> Enum.map(fn line -> line.translated_text end)
    |> Enum.join("\n\n")
  end
end
