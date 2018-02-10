defmodule Docdog.Editor.Project do
  @moduledoc """
    The Project representation.
  """

  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset

  alias Docdog.Editor.Project

  schema "projects" do
    field(:name, :string)
    field(:completed_percentage, :decimal, virtual: true)

    timestamps()

    belongs_to(:user, Docdog.Accounts.User)

    has_many(:documents, Docdog.Editor.Document, on_delete: :delete_all)
  end

  @doc false
  def changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end

  def with_completed_percentages_query do
    documents_subquery =
      from(
        p in Docdog.Editor.Project,
        select: %{
          id: p.id,
          completed_percentage: fragment("count(l2.translated_text) * 100.0 / count(p0.id)")
        },
        left_join: d in assoc(p, :documents),
        left_join: l in assoc(d, :lines),
        group_by: [p.id, d.id]
      )

    projects_subquery =
      from(
        s in subquery(documents_subquery),
        select: %{
          id: s.id,
          completed_percentage: fragment("round(sum(s0.completed_percentage) / count(*), 2)")
        },
        group_by: s.id
      )

    from(
      p in Docdog.Editor.Project,
      join: s in subquery(projects_subquery),
      on: p.id == s.id,
      select: %{p | completed_percentage: s.completed_percentage},
      distinct: p.id
    )
  end
end
