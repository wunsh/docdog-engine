defmodule DocdogWeb.ProjectControllerTest do
  use DocdogWeb.ConnCase

  import Docdog.Factory

  @create_attrs string_params_for(:project, %{name: "Phoenix Documentation"})
  @update_attrs %{"name" => "Updated Phoenix Documentation"}
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

    project =
      insert(
        :project,
        user: user,
        name: "Elixir Documentation 1",
        description: "Official documentation of Elixir language"
      )

    project_with_documents =
      insert(:project, name: "Elixir Documentation 2", user: user)
      |> with_documents

    _project_of_another_user =
      insert(:project, name: "Another User Project", user: another_user)

    {:ok,
     conn: conn,
     another_conn: conn_with_another_user,
     project: project,
     project_with_documents: project_with_documents}
  end

  describe "index" do
    test "lists main user projects", %{conn: conn} do
      conn = get(conn, project_path(conn, :index))
      assert html_response(conn, 200) =~ "Elixir Documentation 1"

      assert html_response(conn, 200) =~
               "Official documentation of Elixir language"

      assert html_response(conn, 200) =~ "Elixir Documentation 2"
      assert html_response(conn, 200) =~ "No description"

      refute html_response(conn, 200) =~ "Another User Project"
    end
  end

  describe "new project" do
    test "renders form", %{conn: conn} do
      conn = get(conn, project_path(conn, :new))
      assert html_response(conn, 200) =~ "New Project"
      assert html_response(conn, 200) =~ "Description"
    end
  end

  describe "create project" do
    test "redirects to show when data is valid", %{conn: conn} do
      new_conn = post(conn, project_path(conn, :create), project: @create_attrs)
      assert redirected_to(new_conn) == project_path(new_conn, :index)

      new_conn = get(conn, project_path(conn, :index))
      assert html_response(new_conn, 200) =~ "Phoenix Documentation"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, project_path(conn, :create), project: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Project"
    end
  end

  describe "edit project" do
    test "renders form for editing chosen project", %{
      conn: conn,
      project: project
    } do
      conn = get(conn, project_path(conn, :edit, project))
      assert html_response(conn, 200) =~ "Edit Project"
    end

    test "renders unauthorized page for another user", %{
      another_conn: conn,
      project: project
    } do
      conn = get(conn, project_path(conn, :edit, project))
      assert html_response(conn, 403) =~ "Forbidden"
    end
  end

  describe "update project" do
    test "redirects when data is valid", %{conn: conn, project: project} do
      new_conn =
        put(conn, project_path(conn, :update, project), project: @update_attrs)

      assert redirected_to(new_conn) == project_path(new_conn, :index)

      new_conn = get(conn, project_path(conn, :index))
      assert html_response(new_conn, 200) =~ "Updated Phoenix Documentation"
    end

    test "renders errors when data is invalid", %{conn: conn, project: project} do
      conn =
        put(conn, project_path(conn, :update, project), project: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Project"
    end

    test "renders unauthorized page for another user", %{
      another_conn: conn,
      project: project
    } do
      conn =
        put(conn, project_path(conn, :update, project), project: @invalid_attrs)

      assert html_response(conn, 403) =~ "Forbidden"
    end
  end

  describe "delete project" do
    test "deletes chosen project", %{conn: conn, project: project} do
      conn = delete(conn, project_path(conn, :delete, project))
      assert redirected_to(conn) == project_path(conn, :index)
    end

    test "deletes chosen project with documents", %{
      conn: conn,
      project_with_documents: project_with_documents
    } do
      conn = delete(conn, project_path(conn, :delete, project_with_documents))
      assert redirected_to(conn) == project_path(conn, :index)
    end

    test "renders unauthorized page for another user", %{
      another_conn: conn,
      project: project
    } do
      conn = delete(conn, project_path(conn, :delete, project))
      assert html_response(conn, 403) =~ "Forbidden"
    end
  end
end
