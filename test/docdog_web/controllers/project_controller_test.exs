# defmodule DocdogWeb.ProjectControllerTest do
#   use DocdogWeb.ConnCase

#   alias Docdog.Editor

#   @create_attrs %{name: "some name"}
#   @update_attrs %{name: "some updated name"}
#   @invalid_attrs %{name: nil}

#   def fixture(:project) do
#     {:ok, project} = Editor.create_project(@create_attrs)
#     project
#   end

#   describe "index" do
#     test "lists all projects", %{conn: conn} do
#       conn = get(conn, project_path(conn, :index))
#       assert html_response(conn, 200) =~ "Listing Projects"
#     end
#   end

#   describe "new project" do
#     test "renders form", %{conn: conn} do
#       conn = get(conn, project_path(conn, :new))
#       assert html_response(conn, 200) =~ "New Project"
#     end
#   end

#   describe "create project" do
#     test "redirects to show when data is valid", %{conn: conn} do
#       conn = post(conn, project_path(conn, :create), project: @create_attrs)

#       assert %{id: id} = redirected_params(conn)
#       assert redirected_to(conn) == project_path(conn, :show, id)

#       conn = get(conn, project_path(conn, :show, id))
#       assert html_response(conn, 200) =~ "Show Project"
#     end

#     test "renders errors when data is invalid", %{conn: conn} do
#       conn = post(conn, project_path(conn, :create), project: @invalid_attrs)
#       assert html_response(conn, 200) =~ "New Project"
#     end
#   end

#   describe "edit project" do
#     setup [:create_project]

#     test "renders form for editing chosen project", %{conn: conn, project: project} do
#       conn = get(conn, project_path(conn, :edit, project))
#       assert html_response(conn, 200) =~ "Edit Project"
#     end
#   end

#   describe "update project" do
#     setup [:create_project]

#     test "redirects when data is valid", %{conn: conn, project: project} do
#       conn = put(conn, project_path(conn, :update, project), project: @update_attrs)
#       assert redirected_to(conn) == project_path(conn, :show, project)

#       conn = get(conn, project_path(conn, :show, project))
#       assert html_response(conn, 200) =~ "some updated name"
#     end

#     test "renders errors when data is invalid", %{conn: conn, project: project} do
#       conn = put(conn, project_path(conn, :update, project), project: @invalid_attrs)
#       assert html_response(conn, 200) =~ "Edit Project"
#     end
#   end

#   describe "delete project" do
#     setup [:create_project]

#     test "deletes chosen project", %{conn: conn, project: project} do
#       conn = delete(conn, project_path(conn, :delete, project))
#       assert redirected_to(conn) == project_path(conn, :index)

#       assert_error_sent(404, fn ->
#         get(conn, project_path(conn, :show, project))
#       end)
#     end
#   end

#   defp create_project(_) do
#     project = fixture(:project)
#     {:ok, project: project}
#   end
# end
