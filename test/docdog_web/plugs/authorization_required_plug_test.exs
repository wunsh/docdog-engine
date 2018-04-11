defmodule DocdogWeb.AuthorizationRequiredPlugTest do
  use DocdogWeb.ConnCase
  use Plug.Test

  import Docdog.Factory

  alias DocdogWeb.AuthorizationRequiredPlug

  describe "when no user in assigns" do
    setup do
      conn =
        build_conn(:get, "/workplace/projects")
        |> init_test_session(%{})
        |> fetch_flash()
        |> AuthorizationRequiredPlug.init()
        |> AuthorizationRequiredPlug.call(%{})

      {:ok, conn: conn}
    end

    test "redirects to sign in page with proper redirect url and flash message",
         %{conn: conn} do
      assert get_session(conn, :redirect_url) == "/workplace/projects"
      assert get_flash(conn, :info) == "Please, sign in to continue."
      assert redirected_to(conn) == "/auth/sign_in"
    end
  end

  describe "when user in assigns" do
    setup do
      user = insert(:user)

      initial_conn =
        build_conn()
        |> assign(:current_user, user)

      conn =
        initial_conn
        |> AuthorizationRequiredPlug.init()
        |> AuthorizationRequiredPlug.call(%{})

      {:ok, conn: conn, initial_conn: initial_conn}
    end

    test "current user brings just from assigns when no session", %{
      conn: conn,
      initial_conn: initial_conn
    } do
      assert initial_conn == conn
    end
  end
end
