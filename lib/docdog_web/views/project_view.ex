defmodule DocdogWeb.ProjectView do
  use DocdogWeb, :view

  def description(project) do
    project.description || "No description"
  end
end
