defmodule DocdogWeb.LineControllerTest do
  use DocdogWeb.ConnCase

  import Docdog.Factory

  setup do
    user = insert(:user)

    conn =
      build_conn()
      |> assign(:current_user, user)

    processed_line = insert(:processed_line)
    unprocessed_line = insert(:unprocessed_line)

    project = insert(:project, user: user)

    document =
      insert(:document, user: user, project: project, lines: [processed_line, unprocessed_line])

    {:ok, conn: conn, user: user, unprocessed_line: unprocessed_line, document: document}
  end

  describe "index" do
    test "lists all lines in json format", %{conn: conn, document: document} do
      [line1, line2] = document.lines

      conn = get(conn, document_line_path(conn, :index, document.id))

      assert json_response(conn, 200) == %{
               "data" => [
                 %{
                   "id" => line1.id,
                   "index_number" => 1,
                   "original_text" => "Elixir is",
                   "processed" => true,
                   "translated_text" => "Эликсир - это"
                 },
                 %{
                   "id" => line2.id,
                   "index_number" => 2,
                   "original_text" => "the best language.",
                   "processed" => false,
                   "translated_text" => nil
                 }
               ]
             }
    end
  end

  describe "update line" do
    test "updates line and show updated line back when data is valid", %{
      conn: conn,
      unprocessed_line: line
    } do
      conn =
        put(
          conn,
          line_path(conn, :update, line.id),
          line: %{"translated_text" => "самый лучший язык программирования."}
        )

      assert json_response(conn, 200) == %{
               "id" => line.id,
               "index_number" => 2,
               "original_text" => "the best language.",
               "processed" => true,
               "translated_text" => "самый лучший язык программирования."
             }
    end

    test "renders errors when data is invalid", %{conn: conn, unprocessed_line: line} do
      conn = put(conn, line_path(conn, :update, line.id), line: %{"translated_text" => nil})
      assert json_response(conn, 400) == %{"status" => "error"}
    end
  end
end
