defmodule Docdog.Editor.Document do
  use Ecto.Schema

  import Ecto.Changeset

  alias Docdog.Editor.Document
  alias Docdog.Editor.Line

  schema "documents" do
    field :name, :string
    field :original_text, :string

    timestamps()

    belongs_to :project, Docdog.Editor.Project

    has_many :lines, Docdog.Editor.Line, on_replace: :mark_as_invalid
  end

  @doc false
  def changeset(%Document{} = document, attrs) do
    document
    |> cast(attrs, [:name, :original_text])
    |> validate_required([:name, :original_text])
    |> put_assoc(:lines, create_lines(attrs["original_text"]))
  end

  def translated_text(lines) do
    lines
    |> Enum.map(fn(x) -> x.translated_text end )
    |> Enum.join("\n")
  end

  defp create_lines(nil) do
    []
  end

  defp create_lines(text) do
    text
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.with_index
    |> Enum.map(&Line.prepare_line/1)
  end
end
