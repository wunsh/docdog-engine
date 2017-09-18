defmodule DocdogWeb.LineController do
  use DocdogWeb, :controller

  alias Docdog.Editor

  def update(conn, %{"id" => id, "line" => line_params}) do
    line = Editor.get_line!(id)

    case Editor.update_line(line, conn.assigns.current_user, line_params) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{"status": "ok"})
      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_status(:bad_request)
        |> json(%{"status": "error"})
    end
  end
end
