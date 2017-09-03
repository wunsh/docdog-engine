require IEx

defmodule DocdogWeb.DocumentController do
  use DocdogWeb, :controller

  alias Docdog.Editor
  alias Docdog.Editor.Document

  def index(conn, %{"project_id" => project_id}) do
    documents = Editor.get_project!(project_id).documents
    render(conn, "index.html", documents: documents)
  end

  def new(conn, _params) do
    changeset = Editor.change_document(%Document{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"document" => document_params, "project_id" => project_id}) do
    project = Editor.get_project!(project_id)

    case Editor.create_document(project, document_params) do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Document created successfully.")
        |> redirect(to: project_document_path(conn, :show, project, document))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    document = Editor.get_document!(id)
    render(conn, "show.html", document: document)
  end

  def edit(conn, %{"id" => id}) do
    document = Editor.get_document!(id)
    changeset = Editor.change_document(document)
    render(conn, "edit.html", document: document, changeset: changeset)
  end

  def update(conn, %{"id" => id, "document" => document_params, "project_id" => project_id}) do
    document = Editor.get_document!(id)

    case Editor.update_document(document, document_params) do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Document updated successfully.")
        |> redirect(to: project_document_path(conn, :show, project_id, document))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", document: document, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "project_id" => project_id}) do
    document = Editor.get_document!(id)
    {:ok, _document} = Editor.delete_document(document)

    conn
    |> put_flash(:info, "Document deleted successfully.")
    |> redirect(to: project_document_path(conn, :index, project_id))
  end
end
