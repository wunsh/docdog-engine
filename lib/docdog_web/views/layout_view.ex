defmodule DocdogWeb.LayoutView do
  use DocdogWeb, :view

  def base_layout(conn, opts \\ [], do: contents) when is_list(opts) do
    render("base.html", [conn: conn, contents: contents] ++ opts)
  end
end
