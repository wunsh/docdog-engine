defmodule Docdog.Editor.Queries.DocumentQuery do
  @moduledoc """
  Defines document queries.
  """

  import Ecto.Query, warn: false

  def default_scope(query) do
    from(
      d in query,
      preload: [:user, :lines, project: :user],
      order_by: [desc: :inserted_at]
    )
  end
end
