defmodule DocdogWeb.AuthorizationRequiredPlug do
  @moduledoc """
    Require authorization for action.
  """

  import Plug.Conn
  import Phoenix.Controller
  import DocdogWeb.Router.Helpers, only: [auth_path: 2]

  def init(default) do
    default
  end

  def call(conn, _opts) do
    case Map.has_key?(conn.assigns, :current_user) do
      false ->
        conn
        |> put_session(:redirect_url, conn.request_path)
        |> put_flash(:info, "Please, sign in to continue.")
        |> redirect(to: auth_path(conn, :new))
      _ ->
        conn
    end
  end
end
