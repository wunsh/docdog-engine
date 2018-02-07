defmodule DocdogWeb.CurrentUserPlug do
  @moduledoc """
    Getting current user from session.
  """

  import Plug.Conn

  def init(default) do
    default
  end

  def call(conn, _opts) do
    if current_user = get_session(conn, :current_user) do
      assign(conn, :current_user, current_user)
    else
      conn
    end
  end
end
