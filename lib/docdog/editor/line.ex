defmodule Docdog.Editor.Line do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Docdog.Editor.Line


  schema "lines" do
    field :original_text, :string
    field :translated_text, :string
    field :index_number, :integer

    timestamps()

    belongs_to :document, Docdog.Editor.Document
  end

  @doc false
  def changeset(%Line{} = line, attrs) do
    line
    |> cast(attrs, [:translated_text])
    |> validate_required([:translated_text])
  end

  def prepare_line({original_line, index}) do
    %{}
    |> Map.put(:original_text, original_line)
    |> Map.put(:index_number, index)
  end

  def default_scope(query) do
    from line in query,
      order_by: [asc: :index_number]
  end
end
