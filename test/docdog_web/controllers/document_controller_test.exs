defmodule DocdogWeb.DocumentControllerTest do
  use DocdogWeb.ConnCase

  import Docdog.Factory

  @create_attrs string_params_for(:document)
  @invalid_attrs %{"name" => nil}

  setup do
    user = insert(:user)
    another_user = insert(:user)

    conn =
      build_conn()
      |> assign(:current_user, user)

    conn_with_another_user =
      build_conn()
      |> assign(:current_user, another_user)

    line = build(:processed_line)
    public_project = insert(:project, user: user, public: true)
    private_project = insert(:project, user: user, public: false)

    document =
      insert(
        :document,
        user: user,
        project: public_project,
        lines: [line, line]
      )

    {:ok,
     conn: conn,
     another_conn: conn_with_another_user,
     user: user,
     private_project: private_project,
     public_project: public_project,
     document: document}
  end

  describe "index" do
    test "lists all documents of public project for author user", %{
      conn: conn,
      public_project: project
    } do
      conn = get(conn, project_document_path(conn, :index, project.id))
      assert html_response(conn, 200) =~ "Listing Documents"
    end

    test "renders all documents of public project for another user", %{
      another_conn: conn,
      public_project: project
    } do
      conn = get(conn, project_document_path(conn, :index, project.id))
      assert html_response(conn, 200) =~ "Listing Documents"
    end

    test "renders unauthorized page for another user private project", %{
      another_conn: conn,
      private_project: project
    } do
      conn = get(conn, project_document_path(conn, :index, project.id))
      assert html_response(conn, 403) =~ "Forbidden"
    end
  end

  describe "show document" do
    test "shows the document in html format", %{
      conn: conn,
      public_project: project,
      document: document
    } do
      conn =
        get(conn, project_document_path(conn, :show, project.id, document.id))

      assert html_response(conn, 200) =~ "Show Document"
    end

    test "saves the document in md format", %{
      conn: conn,
      public_project: project,
      document: document
    } do
      conn = conn |> put_req_header("accept", "text/markdown")

      conn =
        get(conn, project_document_path(conn, :show, project.id, document.id))

      assert response_content_type(conn, :md) =~ "text/markdown; charset=utf-8"
      assert response(conn, 200) == "Эликсир - это\n\nЭликсир - это"
    end

    test "renders unauthorized page for another user private project", %{
      another_conn: conn,
      user: user,
      private_project: project
    } do
      document = insert(:document, user: user, project: project)

      conn =
        get(conn, project_document_path(conn, :show, project.id, document.id))

      assert html_response(conn, 403) =~ "Forbidden"
    end
  end

  describe "new document" do
    test "renders form", %{conn: conn, public_project: project} do
      conn = get(conn, project_document_path(conn, :new, project.id))
      assert html_response(conn, 200) =~ "New Document"
    end

    test "renders unauthorized page for another user private project", %{
      another_conn: conn,
      private_project: project
    } do
      conn = get(conn, project_document_path(conn, :new, project.id))
      assert html_response(conn, 403) =~ "Forbidden"
    end
  end

  describe "create document" do
    test "redirects to show when data is valid", %{
      conn: conn,
      public_project: project
    } do
      new_conn =
        post(
          conn,
          project_document_path(conn, :create, project.id),
          document: @create_attrs
        )

      assert %{id: id} = redirected_params(new_conn)

      assert redirected_to(new_conn) ==
               project_document_path(new_conn, :edit, project.id, id)

      new_conn = get(conn, project_document_path(conn, :edit, project.id, id))
      assert html_response(new_conn, 200) =~ "Edit Document"
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      public_project: project
    } do
      conn =
        post(
          conn,
          project_document_path(conn, :create, project.id),
          document: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "New Document"
    end

    test "renders unauthorized page for another user private project", %{
      another_conn: conn,
      private_project: project
    } do
      conn =
        post(
          conn,
          project_document_path(conn, :create, project.id),
          document: @invalid_attrs
        )

      assert html_response(conn, 403) =~ "Forbidden"
    end
  end

  describe "edit document" do
    test "renders form for editing chosen document", %{
      conn: conn,
      public_project: project,
      document: document
    } do
      conn = get(conn, project_document_path(conn, :edit, project.id, document))
      assert html_response(conn, 200) =~ "Edit Document"
    end

    test "renders unauthorized page for another user private project", %{
      another_conn: conn,
      user: user,
      private_project: project
    } do
      document = insert(:document, user: user, project: project)
      conn = get(conn, project_document_path(conn, :edit, project.id, document))
      assert html_response(conn, 403) =~ "Forbidden"
    end
  end

  describe "delete document" do
    test "renders unauthorized page for document of private project for admin",
         %{
           conn: conn,
           public_project: project,
           document: document
         } do
      admin = insert(:user, admin: true)
      conn = assign(conn, :current_user, admin)

      delete_conn =
        delete(conn, project_document_path(conn, :delete, project.id, document))

      assert redirected_to(delete_conn) ==
               project_document_path(conn, :index, project.id)

      assert_error_sent(404, fn ->
        get(conn, project_document_path(conn, :show, project.id, document))
      end)
    end

    test "renders unauthorized page for regular user public project", %{
      conn: conn,
      public_project: project,
      document: document
    } do
      delete_conn =
        delete(conn, project_document_path(conn, :delete, project.id, document))

      assert html_response(delete_conn, 403) =~ "Forbidden"
    end

    test "renders unauthorized page for another user private project", %{
      another_conn: conn,
      user: user,
      private_project: project
    } do
      document = insert(:document, user: user, project: project)

      delete_conn =
        delete(conn, project_document_path(conn, :delete, project.id, document))

      assert html_response(delete_conn, 403) =~ "Forbidden"
    end
  end
end
