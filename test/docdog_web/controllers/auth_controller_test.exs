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

  test "lists all documents", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @create_attrs_from_github)
      |> post(auth_path(conn, :callback, :github))

    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :info) == "Successfully authenticated."
  end

  test "lists all documents33", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @invalid_attrs_from_github)
      |> post(auth_path(conn, :callback, :github))

    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :error) == [email: {"can't be blank", [validation: :required]}]
  end

  test "lists all documents2", %{conn: conn} do
    conn = assign(conn, :ueberauth_failure, @failure_attrs_from_github)

    conn = get(conn, auth_path(conn, :callback, :github))
    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :error) == "Failed to authenticate."
  end
end
