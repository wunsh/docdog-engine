defmodule DocdogWeb.ProjectInviteController do
  use DocdogWeb, :controller

  plug DocdogWeb.AuthorizationRequiredPlug

  alias Docdog.Editor
  alias Docdog.Editor.Project

  def show(conn, %{"invite_code" => invite_code}) do
    project = Editor.get_project_by_invite_code!(invite_code)

    render(conn, "show.html", project: project)
  end

  def create(conn, %{"invite_code" => invite_code}) do
    user = conn.assigns.current_user
    project = Editor.get_project_by_invite_code!(invite_code)

    with :ok <- Bodyguard.permit(
        Editor, :project_accept_invite, user, project: project
      ),
         {:ok, _project} <- Editor.add_member_to_project(project, user) do
      conn
      |> put_flash(:info, "You successfully became a project member.")
      |> redirect(to: project_document_path(conn, :index, project.id))
    else
      {:error, %Ecto.Changeset{} = _} ->
        conn
        |> put_flash(:error, "You've got error on accepting invite.")
        |> render("show.html", project: project)

      error ->
        error
    end
  end
end
