defmodule DocdogWeb.PageControllerTest do
  use DocdogWeb.ConnCase

  describe "when guest" do
    test "GET /", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Docdog App"
    end
  end

  describe "when logged in user" do
    setup do
      conn =
        build_conn()
        |> assign(:current_user, %Docdog.Accounts.User{})

      {:ok, conn: conn}
    end

    test "GET /", %{conn: conn} do
      conn = get(conn, "/")
      assert redirected_to(conn) =~ "/workplace/projects"
    end
  end
end
