defmodule Docdog.Editor.Line do
  @moduledoc """
    The Line representation.
    There are lines from which documents are composed.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Docdog.Editor.Line

  schema "lines" do
    field :original_text, :string
    field :translated_text, :string
    field :index_number, :integer
    field :processed, :boolean, default: false

    timestamps()

    belongs_to :document, Docdog.Editor.Document
    belongs_to :user, Docdog.Accounts.User
  end

  @doc false
  def changeset(%Line{} = line, attrs) do
    line
    |> cast(attrs, [:translated_text, :user_id])
    |> validate_required([:user_id])
    |> make_processed
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

  defp make_processed(changeset) do
    put_change(changeset, :processed, true)
  end
end
