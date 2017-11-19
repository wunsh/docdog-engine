defmodule DocdogWeb.PageController do
  use DocdogWeb, :controller

  def index(conn, _params) do
    if user = conn.assigns[:current_user] do
      conn
      |> redirect(to: "/projects")
    else
      render conn, "index.html"
    end
  end
end
