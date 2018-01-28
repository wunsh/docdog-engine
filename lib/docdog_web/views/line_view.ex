defmodule DocdogWeb.LineView do
  use DocdogWeb, :view

  def render("index.json", %{lines: lines}) do
    %{data: render_many(lines, DocdogWeb.LineView, "line.json")}
  end

  def render("line.json", %{line: line}) do
    %{
      id: line.id,
      original_text: line.original_text,
      translated_text: line.translated_text,
      index_number: line.index_number,
      processed: line.processed
    }
  end
end
