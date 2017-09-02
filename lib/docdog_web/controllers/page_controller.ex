defmodule DocdogWeb.PageController do
  use DocdogWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
