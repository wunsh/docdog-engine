defmodule DocdogWeb.AuthControllerTest do
  import Plug.Test
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
    info: %{nickname: "foobar", email: "some@email.com", name: "dsfdsf", image: "dfsdf"}
  }

  @failure_attrs_from_github %Ueberauth.Failure{}

  test "lists all documents", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @create_attrs_from_github)
      |> post(auth_path(conn, :callback, :github))

    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :info) == "Successfully authenticated."
    assert get_session(conn, :current_user)
  end

  test "lists all documents33", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @invalid_attrs_from_github)
      |> post(auth_path(conn, :callback, :github))

    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "lists all documents2", %{conn: conn} do
    conn = assign(conn, :ueberauth_failure, @failure_attrs_from_github)

    conn = get(conn, auth_path(conn, :callback, :github))
    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :error) == "Failed to authenticate."
    refute get_session(conn, :current_user)
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
