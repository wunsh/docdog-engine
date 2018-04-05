defmodule DocdogWeb.AuthControllerTest do
  use DocdogWeb.ConnCase
  use Plug.Test

  @create_attrs_from_github %Ueberauth.Auth{
    info: %{
      email: "petrov@example.com",
      nickname: "petr_petrov",
      name: "Petr Petroff",
      first_name: "Petr",
      last_name: "Petrov",
      image: ""
    }
  }

  @invalid_attrs_from_github %Ueberauth.Auth{
    info: %{nickname: "foobar", email: "some@email.com", name: "dsfdsf", image: "dfsdf"}
  }

  @failure_attrs_from_github %Ueberauth.Failure{}

  test "loads sign in page", %{conn: conn} do
    conn = get conn, "/auth/sign_in"

    assert html_response(conn, 200) =~ "<h1>Built for developers and professional translators</h1>"
    assert html_response(conn, 200) =~ ">Sign in with Github</a>"
  end

  test "when success auth from Github authenticates user", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @create_attrs_from_github)
      |> post(auth_path(conn, :callback, :github))

    assert redirected_to(conn) == "/workplace/popular"
    assert get_flash(conn, :info) == "Successfully authenticated."
    assert html_response(conn, 302) =~ "You are being <a href=\"/workplace/popular\">redirected</a>."
  end

  test "when success auth from Github authenticates user and redirect url is /auth/sign_in", %{conn: conn} do
    conn =
      conn
      |> init_test_session(%{redirect_url: "/auth/sign_in"})
      |> assign(:ueberauth_auth, @create_attrs_from_github)
      |> post(auth_path(conn, :callback, :github))

    assert redirected_to(conn) == "/workplace/popular"
    assert html_response(conn, 302) =~ "You are being <a href=\"/workplace/popular\">redirected</a>."
  end

  test "when success auth from Github authenticates user and redirect url is /workplace/projects/123", %{conn: conn} do
    conn =
      conn
      |> init_test_session(%{redirect_url: "/workplace/projects/123"})
      |> assign(:ueberauth_auth, @create_attrs_from_github)
      |> post(auth_path(conn, :callback, :github))

    assert redirected_to(conn) == "/workplace/projects/123"
    assert html_response(conn, 302) =~ "You are being <a href=\"/workplace/projects/123\">redirected</a>."
  end

  test "when success auth from Github, but errors in model redirects to sign in page with error", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @invalid_attrs_from_github)
      |> post(auth_path(conn, :callback, :github))

    assert redirected_to(conn) == "/auth/sign_in"
    assert get_flash(conn, :error) == [email: {"can't be blank", [validation: :required]}]
  end

  test "when failure from Github redirects back with error", %{conn: conn} do
    conn = assign(conn, :ueberauth_failure, @failure_attrs_from_github)

    conn = get(conn, auth_path(conn, :callback, :github))
    assert redirected_to(conn) == "/auth/sign_in"
    assert get_flash(conn, :error) == "Failed to authenticate."
    assert html_response(conn, 302) =~ "You are being <a href=\"/auth/sign_in\">redirected</a>"
    refute get_session(conn, :current_user)
  end

  test "when guest try to open workplace", %{conn: _} do
    # TODO: Implement
  end

  test "logout", %{conn: conn} do
    conn =
      conn
      |> init_test_session(current_user: "a user")
      |> delete(auth_path(conn, :delete))

    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :info) == "Successfully logged out."
    refute get_session(conn, :current_user)
  end
end
