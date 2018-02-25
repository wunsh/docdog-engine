defmodule Docdog.Editor.Queries.LineQuery do
  import Ecto.Query, warn: false

  def default_scope(query) do
    from(
      l in query,
      preload: [:user, document: :user],
      order_by: [asc: :index_number]
    )
  end
end
