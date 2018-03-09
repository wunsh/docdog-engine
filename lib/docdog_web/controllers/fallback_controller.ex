defmodule DocdogWeb.FallbackController do
  use DocdogWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> render(DocdogWeb.ErrorView, :"403")
  end
end
