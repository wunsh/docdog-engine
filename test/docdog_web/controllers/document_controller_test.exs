defmodule DocdogWeb.DocumentControllerTest do
  use DocdogWeb.ConnCase

  import Docdog.Factory

  @create_attrs string_params_for(:document)
  @invalid_attrs %{"name" => nil}

  setup do
    user = insert(:user)

    conn =
      build_conn()
      |> assign(:current_user, user)

    line = build(:processed_line)
    project = insert(:project, user: user)
    document = insert(:document, user: user, project: project, lines: [line, line])

    {:ok, conn: conn, user: user, project: project, document: document}
  end

  describe "index" do
    test "lists all documents", %{conn: conn, project: project} do
      conn = get(conn, project_document_path(conn, :index, project.id))
      assert html_response(conn, 200) =~ "Listing Documents"
    end
  end

  describe "show document" do
    test "shows the document in html format", %{conn: conn, project: project, document: document} do
      conn = get(conn, project_document_path(conn, :show, project.id, document.id))
      assert html_response(conn, 200) =~ "Show Document"
    end

    test "saves the document in md format", %{conn: conn, project: project, document: document} do
      conn = conn |> put_req_header("accept", "text/markdown")
      conn = get(conn, project_document_path(conn, :show, project.id, document.id))
      assert response_content_type(conn, :md) =~ "text/markdown; charset=utf-8"
      assert response(conn, 200) == "Эликсир - это\nЭликсир - это"
    end
  end

  describe "new document" do
    test "renders form", %{conn: conn, project: project} do
      conn = get(conn, project_document_path(conn, :new, project.id))
      assert html_response(conn, 200) =~ "New Document"
    end
  end

  describe "create document" do
    test "redirects to show when data is valid", %{conn: conn, project: project} do
      new_conn =
        post(conn, project_document_path(conn, :create, project.id), document: @create_attrs)

      assert %{id: id} = redirected_params(new_conn)
      assert redirected_to(new_conn) == project_document_path(new_conn, :edit, project.id, id)

      new_conn = get(conn, project_document_path(conn, :edit, project.id, id))
      assert html_response(new_conn, 200) =~ "Edit Document"
    end

    test "renders errors when data is invalid", %{conn: conn, project: project} do
      conn =
        post(conn, project_document_path(conn, :create, project.id), document: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Document"
    end
  end

  describe "edit document" do
    test "renders form for editing chosen document", %{
      conn: conn,
      project: project,
      document: document
    } do
      conn = get(conn, project_document_path(conn, :edit, project.id, document))
      assert html_response(conn, 200) =~ "Edit Document"
    end
  end

  describe "delete document" do
    test "deletes chosen document", %{conn: conn, project: project, document: document} do
      conn = delete(conn, project_document_path(conn, :delete, project.id, document))
      assert redirected_to(conn) == project_document_path(conn, :index, project.id)

      assert_error_sent(404, fn ->
        get(conn, project_document_path(conn, :show, project.id, document))
      end)
    end
  end
end
