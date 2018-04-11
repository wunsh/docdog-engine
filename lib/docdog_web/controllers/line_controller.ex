defmodule DocdogWeb.LineController do
  use DocdogWeb, :controller

  plug DocdogWeb.AuthorizationRequiredPlug

  alias Docdog.Editor

  def index(conn, %{"document_id" => document_id}) do
    # TODO: Fix
    user = get_session(conn, :current_user) || conn.assigns.current_user
    document = Editor.get_document!(document_id)
    lines = Editor.get_lines_for_document(document)

    with :ok <-
           Bodyguard.permit(
             Editor,
             :document_update,
             user,
             document: document,
             project: document.project
           ) do
      render(conn, "index.json", lines: lines)
    end
  end

  def update(conn, %{"id" => id, "line" => line_params}) do
    # TODO: Fix
    user = get_session(conn, :current_user) || conn.assigns.current_user
    line = Editor.get_line!(id)

    with :ok <- Bodyguard.permit(
        Editor, :line_update, user, line: line, project: line.project
      ),
         {:ok, updated_line} <- Editor.update_line(line, user, line_params) do
      conn
      |> put_status(:ok)
      |> render("line.json", line: updated_line)
    else
      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_status(:bad_request)
        |> json(%{status: "error"})

      error ->
        error
    end
  end
end
