defmodule DocdogWeb.PageController do
  use DocdogWeb, :controller

  import DocdogWeb.Router.Helpers

  alias DocdogWeb.Endpoint

  def index(conn, _params) do
    if conn.assigns[:current_user] do
      redirect(conn, to: popular_path(Endpoint, :index))
    else
      render(conn, "index.html")
    end
  end
end
