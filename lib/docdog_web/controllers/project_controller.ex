defmodule DocdogWeb.ProjectController do
  use DocdogWeb, :controller

  plug DocdogWeb.AuthorizationRequiredPlug

  alias Docdog.Editor
  alias Docdog.Editor.Project

  def index(conn, _params) do
    user = conn.assigns.current_user
    projects = Editor.full_list_projects(user)

    render(conn, "index.html", projects: projects)
  end

  def new(conn, _params) do
    user = conn.assigns.current_user
    changeset = Editor.change_project(%Project{})

    with :ok <- Bodyguard.permit(Editor, :project_create, user) do
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"project" => project_params}) do
    user = conn.assigns.current_user

    with :ok <- Bodyguard.permit(Editor, :project_create, user),
         {:ok, _project} <- Editor.create_project(user, project_params) do
      conn
      |> put_flash(:info, "Project created successfully.")
      |> redirect(to: project_path(conn, :index))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    project = Editor.get_project!(id)
    changeset = Editor.change_project(project)

    with :ok <- Bodyguard.permit(Editor, :project_update, user, project: project) do
      render(conn, "edit.html", project: project, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    user = conn.assigns.current_user
    project = Editor.get_project!(id)

    with :ok <- Bodyguard.permit(Editor, :project_update, user, project: project),
         {:ok, _project} <- Editor.update_project(project, project_params) do
      conn
      |> put_flash(:info, "Project updated successfully.")
      |> redirect(to: project_path(conn, :index))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", project: project, changeset: changeset)

      error ->
        error
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    project = Editor.get_project!(id)

    with :ok <- Bodyguard.permit(Editor, :project_delete, user, project: project),
         {:ok, _project} <- Editor.delete_project(project) do
      conn
      |> put_flash(:info, "Project deleted successfully.")
      |> redirect(to: project_path(conn, :index))
    end
  end
end
