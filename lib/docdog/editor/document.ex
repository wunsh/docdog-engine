defmodule Docdog.Editor.Document do
  @moduledoc """
    The Document representation.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Docdog.Editor.Document
  alias Docdog.Editor.Line
  alias Docdog.Editor.SnippetHelper

  schema "documents" do
    field(:name, :string)
    field(:original_text, :string)

    timestamps()

    belongs_to(:project, Docdog.Editor.Project)
    belongs_to(:user, Docdog.Accounts.User)

    has_many(:lines, Docdog.Editor.Line, on_replace: :mark_as_invalid, on_delete: :nilify_all)
  end

  @doc false
  def changeset(%Document{} = document, attrs) do
    document
    |> cast(attrs, [:name, :original_text, :user_id])
    |> validate_required([:name, :original_text, :user_id])
    |> put_assoc(:lines, create_lines(attrs["original_text"]))
  end

  def translated_text(lines) do
    lines
    |> Enum.map(fn x -> x.translated_text end)
    |> Enum.join("\n\n")
  end

  defp create_lines(nil) do
    []
  end

  defp create_lines(text) do
    text
    |> SnippetHelper.process_snippets
    |> String.split("\n")
    |> Enum.map(&SnippetHelper.decode_newlines/1)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.with_index()
    |> Enum.map(&Line.prepare_line/1)
  end
end
