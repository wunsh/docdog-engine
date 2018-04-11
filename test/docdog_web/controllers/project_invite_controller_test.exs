defmodule DocdogWeb.ProjectInviteControllerTest do
  use DocdogWeb.ConnCase

  import Docdog.Factory

  setup do
    user = insert(:user)
    another_user = insert(:user)

    conn_with_another_user =
      build_conn()
      |> assign(:current_user, another_user)

    project =
      insert(
        :project,
        user: user,
        name: "Elixir Documentation",
        invite_code: "de4f032e-2fb9-11e8-b467-0ed5f89f718b"
      )

    {:ok, another_conn: conn_with_another_user, project: project}
  end

  describe "index" do
    test "when user signed in shows invite page with Approve button", %{
      another_conn: conn
    } do
      conn =
        get(
          conn,
          project_invite_path(
            conn,
            :show,
            "de4f032e-2fb9-11e8-b467-0ed5f89f718b"
          )
        )

      assert html_response(conn, 200) =~
               "Invite you to «Elixir Documentation» project"

      assert html_response(conn, 200) =~
               "You were invited to project. Please, accept it."

      assert html_response(conn, 200) =~ ">Approve<"
    end
  end

  describe "create" do
    test "adds user to project members and redirects to project docuemnts", %{
      another_conn: conn,
      project: project
    } do
      conn =
        post(
          conn,
          project_invite_path(conn, :create, %{
            invite_code: "de4f032e-2fb9-11e8-b467-0ed5f89f718b"
          })
        )

      assert redirected_to(conn) ==
               "/workplace/projects/#{project.id}/documents"

      assert html_response(conn, 302) =~
               "You are being <a href=\"/workplace/projects/#{project.id}/documents\">redirected</a>."
    end

    test "when error redirects to invite page", %{conn: _} do
      # TODO: Implement
    end
  end
end
