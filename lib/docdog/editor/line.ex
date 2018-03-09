defmodule Docdog.Editor.Line do
  @moduledoc """
    The Line representation.
    There are lines from which documents are composed.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Docdog.Editor.Project
  alias Docdog.Editor.Document
  alias Docdog.Editor.Line
  alias Docdog.Accounts.User

  schema "lines" do
    field(:original_text, :string)
    field(:translated_text, :string)
    field(:index_number, :integer)
    field(:processed, :boolean, default: false)

    timestamps()

    belongs_to(:project, Project)
    belongs_to(:document, Document)
    belongs_to(:user, User)
  end

  @doc false
  def changeset(%Line{} = line, attrs) do
    line
    |> cast(attrs, [:translated_text, :user_id])
    |> validate_required([:translated_text, :user_id])
    |> make_processed
  end

  def prepare_line({original_line, index}) do
    %{}
    |> Map.put(:original_text, original_line)
    |> Map.put(:index_number, index)
  end

  defp make_processed(changeset) do
    put_change(changeset, :processed, true)
  end
end
