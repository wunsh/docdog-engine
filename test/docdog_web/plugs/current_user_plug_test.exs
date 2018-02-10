defmodule DocdogWeb.CurrentUserPlugTest do
  use DocdogWeb.ConnCase
  use Plug.Test

  import Docdog.Factory

  alias DocdogWeb.CurrentUserPlug

  describe "when user in session" do
    setup do
      user = insert(:user)

      conn =
        build_conn()
        |> assign(:current_user, %{})
        |> init_test_session(%{current_user: user})
        |> CurrentUserPlug.init()
        |> CurrentUserPlug.call(%{})

      {:ok, conn: conn, user: user}
    end

    test "current user assigns from session", %{conn: conn, user: user} do
      assert conn.assigns[:current_user] == user
    end
  end

  describe "when user in assigns" do
    setup do
      user = insert(:user)

      conn =
        build_conn()
        |> assign(:current_user, user)
        |> init_test_session(%{})
        |> CurrentUserPlug.init()
        |> CurrentUserPlug.call(%{})

      {:ok, conn: conn, user: user}
    end

    test "current user brings just from assigns when no session", %{conn: conn, user: user} do
      assert conn.assigns[:current_user] == user
    end
  end
end
