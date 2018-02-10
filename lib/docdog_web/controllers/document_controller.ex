defmodule DocdogWeb.DocumentController do
  use DocdogWeb, :controller

  alias Docdog.Editor
  alias Docdog.Editor.Document

  def index(conn, %{"project_id" => project_id}) do
    documents = Editor.get_project!(project_id).documents
    render(conn, "index.html", project_id: project_id, documents: documents)
  end

  def new(conn, %{"project_id" => project_id}) do
    changeset = Editor.change_document(%Document{})
    render(conn, "new.html", project_id: project_id, changeset: changeset)
  end

  def create(conn, %{"document" => document_params, "project_id" => project_id}) do
    project = Editor.get_project!(project_id)
    current_user = conn.assigns.current_user

    case Editor.create_document(project, current_user, document_params) do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Document created successfully.")
        |> redirect(to: project_document_path(conn, :edit, project, document))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", project_id: project_id, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    document = Editor.get_document!(id)

    case get_format(conn) do
      "html" ->
        render(conn, "show.html", document: document)

      "md" ->
        content = Document.translated_text(document.lines)

        conn
        |> put_resp_content_type("text/markdown")
        |> put_resp_header("content-disposition", "attachment; filename=\"#{document.name}.md\"")
        |> send_resp(200, content)
    end
  end

  def edit(conn, %{"id" => id}) do
    document = Editor.get_document!(id)
    lines = Editor.get_lines_for_document(document)

    render(conn, "edit.html", document: document, lines: lines)
  end

  def delete(conn, %{"id" => id, "project_id" => project_id}) do
    document = Editor.get_document!(id)
    {:ok, _document} = Editor.delete_document(document)

    conn
    |> put_flash(:info, "Document deleted successfully.")
    |> redirect(to: project_document_path(conn, :index, project_id))
  end
end
