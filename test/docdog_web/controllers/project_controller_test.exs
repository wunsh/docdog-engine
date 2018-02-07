defmodule DocdogWeb.ProjectControllerTest do
  use DocdogWeb.ConnCase

  import Docdog.Factory

  @create_attrs string_params_for(:project, %{name: "Phoenix Documentation"})
  @update_attrs %{"name" => "Updated Phoenix Documentation"}
  @invalid_attrs %{"name" => nil}

  setup do
    user = insert(:user)

    conn =
      build_conn()
      |> assign(:current_user, user)

    project = insert(:project, user: user)

    {:ok, conn: conn, project: project}
  end

  describe "index" do
    test "lists all projects", %{conn: conn} do
      conn = get(conn, project_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Projects"
    end
  end

  describe "new project" do
    test "renders form", %{conn: conn} do
      conn = get(conn, project_path(conn, :new))
      assert html_response(conn, 200) =~ "New Project"
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
    test "renders form for editing chosen project", %{conn: conn, project: project} do
      conn = get(conn, project_path(conn, :edit, project))
      assert html_response(conn, 200) =~ "Edit Project"
    end
  end

  describe "update project" do
    test "redirects when data is valid", %{conn: conn, project: project} do
      new_conn = put(conn, project_path(conn, :update, project), project: @update_attrs)
      assert redirected_to(new_conn) == project_path(new_conn, :index)

      new_conn = get(conn, project_path(conn, :index))
      assert html_response(new_conn, 200) =~ "Updated Phoenix Documentation"
    end

    test "renders errors when data is invalid", %{conn: conn, project: project} do
      conn = put(conn, project_path(conn, :update, project), project: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Project"
    end
  end

  describe "delete project" do
    test "deletes chosen project", %{conn: conn, project: project} do
      conn = delete(conn, project_path(conn, :delete, project))
      assert redirected_to(conn) == project_path(conn, :index)
    end
  end
end
