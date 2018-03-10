defmodule DocdogWeb.DocumentController do
  use DocdogWeb, :controller

  alias Docdog.Editor
  alias Docdog.Editor.Document

  def index(conn, %{"project_id" => project_id}) do
    user = conn.assigns.current_user
    project = Editor.get_project!(project_id)
    documents = project.documents

    with :ok <- Bodyguard.permit(Editor, :project_read, user, project: project) do
      render(conn, "index.html", project_id: project_id, documents: documents)
    end
  end

  def new(conn, %{"project_id" => project_id}) do
    user = conn.assigns.current_user
    project = Editor.get_project!(project_id)
    changeset = Editor.change_document(%Document{})

    with :ok <- Bodyguard.permit(Editor, :document_create, user, project: project) do
      render(conn, "new.html", project_id: project_id, changeset: changeset)
    end
  end

  def create(conn, %{"document" => document_params, "project_id" => project_id}) do
    user = conn.assigns.current_user
    project = Editor.get_project!(project_id)

    with :ok <- Bodyguard.permit(Editor, :document_create, user, project: project),
         {:ok, document} <- Editor.create_document(project, user, document_params) do
      conn
      |> put_flash(:info, "Document created successfully.")
      |> redirect(to: project_document_path(conn, :edit, project, document))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", project_id: project_id, changeset: changeset)

      error ->
        error
    end
  end

  def show(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    document = Editor.get_document!(id)

    with :ok <-
           Bodyguard.permit(
             Editor,
             :document_read,
             user,
             document: document,
             project: document.project
           ) do
      case get_format(conn) do
        "html" ->
          render(conn, "show.html", document: document)

        "md" ->
          content = Document.translated_text(document)

          conn
          |> put_resp_content_type("text/markdown")
          |> put_resp_header(
            "content-disposition",
            "attachment; filename=\"#{document.name}.md\""
          )
          |> send_resp(200, content)
      end
    end
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    document = Editor.get_document!(id)
    lines = Editor.get_lines_for_document(document)

    with :ok <-
           Bodyguard.permit(
             Editor,
             :document_update,
             user,
             document: document,
             project: document.project
           ) do
      render(conn, "edit.html", document: document, lines: lines)
    end
  end

  def delete(conn, %{"id" => id, "project_id" => project_id}) do
    user = conn.assigns.current_user
    document = Editor.get_document!(id)

    with :ok <-
           Bodyguard.permit(
             Editor,
             :document_delete,
             user,
             document: document,
             project: document.project
           ),
         {:ok, _document} = Editor.delete_document(document) do
      conn
      |> put_flash(:info, "Document deleted successfully.")
      |> redirect(to: project_document_path(conn, :index, project_id))
    end
  end
end
