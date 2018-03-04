defmodule Docdog.Editor.Queries.ProjectQuery do
  import Ecto.Query, warn: false

  alias Docdog.Editor.Project

  def default_scope(query) do
    from(
      p in query,
      preload: [:user, documents: :user],
      order_by: [desc: :inserted_at]
    )
  end

  def popular_scope(query) do
    from(
      p in query,
      where: p.public == true
    )
  end

  def with_completed_percentages do
    documents_subquery =
      from(
        p in Project,
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
      p in Project,
      join: s in subquery(projects_subquery),
      on: p.id == s.id,
      select: %{p | completed_percentage: s.completed_percentage},
      distinct: p.id
    )
  end
end
