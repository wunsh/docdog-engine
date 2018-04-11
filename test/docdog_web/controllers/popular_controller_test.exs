defmodule DocdogWeb.PopularControllerTest do
  use DocdogWeb.ConnCase

  import Docdog.Factory

  setup do
    user = insert(:user)

    conn =
      build_conn()
      |> assign(:current_user, user)

    private_project = insert(:project, name: "Private Project")
    public_project = insert(:project, name: "Public Project", public: true)

    {:ok,
     conn: conn,
     private_project: private_project,
     public_project: public_project}
  end

  describe "index" do
    test "lists popular projects", %{conn: conn} do
      conn = get(conn, popular_path(conn, :index))
      assert html_response(conn, 200) =~ "Popular Projects"
      assert html_response(conn, 200) =~ "Public Project"
      refute html_response(conn, 200) =~ "Private Project"
    end
  end
end
