defmodule DocdogWeb.AuthControllerTest do
  use DocdogWeb.ConnCase

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
    info: %{nickname: "foobar", email: nil, name: "dsfdsf", image: "dfsdf"}
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
  end

  test "when guest try to open workplace", %{conn: conn} do
    # TODO: Implement
  end
end
