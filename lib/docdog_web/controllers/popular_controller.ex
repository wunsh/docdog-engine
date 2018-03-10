defmodule DocdogWeb.PopularController do
  use DocdogWeb, :controller

  alias Docdog.Editor
  alias Docdog.Editor.Project

  def index(conn, _params) do
    projects = Editor.full_list_popular_projects()

    render(conn, "index.html", projects: projects)
  end
end
