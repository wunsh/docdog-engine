defmodule DocdogWeb.AuthController do
  use DocdogWeb, :controller

  plug(Ueberauth)

  alias Docdog.Accounts

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Accounts.find_or_create(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> redirect(to: "/")

      {:error, changeset} ->
        # TODO: Pass humanized errors
        conn
        |> put_flash(:error, changeset.errors)
        |> redirect(to: "/")
    end
  end
end
