defmodule DocdogWeb.AuthController do
  use DocdogWeb, :controller

  plug(Ueberauth)

  alias Docdog.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Successfully logged out.")
    |> delete_session(:current_user)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: auth_path(conn, :new))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    redirect_url = get_session(conn, :redirect_url)

    case Accounts.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> redirect(to: success_redirect_url(conn, redirect_url))

      {:error, changeset} ->
        # TODO: Pass humanized errors
        conn
        |> put_flash(:error, changeset.errors)
        |> redirect(to: auth_path(conn, :new))
    end
  end

  # We mustn't redirect to auth url
  defp success_redirect_url(conn, redirect_url = "/auth" <> _) do
    popular_path(conn, :index)
  end

  defp success_redirect_url(_, redirect_url = "/" <> _) do
    redirect_url
  end

  defp success_redirect_url(conn, _) do
    popular_path(conn, :index)
  end
end
