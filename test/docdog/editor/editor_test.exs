defmodule Docdog.EditorTest do
  use ExUnit.Case
  use Docdog.DataCase

  import Docdog.Factory

  alias Docdog.Editor

  describe "projects" do
    alias Docdog.Editor.Project

    @valid_attrs string_params_for(:project)
    @update_attrs %{"name" => "Phoenix Documentation"}
    @invalid_attrs %{"name" => nil}

    setup do
      user = insert(:user)
      document = insert(:document, user: user)
      project = insert(:project, user: user, documents: [document])

      {:ok, user: user, project: project}
    end

    test "list_projects/0 returns all projects", %{project: project} do
      assert Editor.list_projects() == [project]
    end

    test "full_list_projects/0 returns all projects with completed percentages", %{user: user} do
      processed_line = build(:processed_line)
      unprocessed_line = build(:unprocessed_line)
      document = build(:document, user: user, lines: [processed_line, unprocessed_line])
      project = insert(:project, user: user, documents: [document])

      project_with_percentage =
        Enum.find(Editor.full_list_projects(), fn p -> p.id == project.id end)

      assert Decimal.to_float(project_with_percentage.completed_percentage) == 50.0
    end

    test "get_project!/1 returns the project with given id", %{project: project} do
      assert Editor.get_project!(project.id) == project
    end

    test "create_project/2 with valid data creates a project", %{user: user} do
      assert {:ok, %Project{} = project} = Editor.create_project(user, @valid_attrs)
      assert project.name == "Elixir Documentation"
    end

    test "create_project/2 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Editor.create_project(user, @invalid_attrs)
    end

    test "update_project/2 with valid data updates the project", %{project: project} do
      assert {:ok, project} = Editor.update_project(project, @update_attrs)
      assert %Project{} = project
      assert project.name == "Phoenix Documentation"
    end

    test "update_project/2 with invalid data returns error changeset", %{project: project} do
      assert {:error, %Ecto.Changeset{}} = Editor.update_project(project, @invalid_attrs)
      assert project == Editor.get_project!(project.id)
    end

    test "delete_project/1 deletes the project", %{project: project} do
      assert {:ok, %Project{}} = Editor.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Editor.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset", %{project: project} do
      assert %Ecto.Changeset{} = Editor.change_project(project)
    end
  end

  describe "documents" do
    alias Docdog.Editor.Document

    @valid_attrs string_params_for(:document)
    @update_attrs %{"name" => "Getting Started"}
    @invalid_attrs %{"name" => nil}

    setup do
      user = insert(:user)
      project = insert(:project, user: user)
      document = insert(:document, user: user, project: project, lines: [])

      {:ok, user: user, project: project, document: document}
    end

    test "list_documents/0 returns all documents", %{document: document} do
      assert Editor.list_documents() == [document]
    end

    test "list_documents_for_project/1 returns all documents for given project", %{
      project: project,
      document: document
    } do
      assert Editor.list_documents_for_project(project.id) == [document]
    end

    test "get_document!/1 returns the document with given id", %{document: document} do
      assert Editor.get_document!(document.id) == document
    end

    test "create_document/3 with valid data creates a document", %{project: project, user: user} do
      assert {:ok, %Document{} = document} = Editor.create_document(project, user, @valid_attrs)
      assert document.name == "Introduction"
    end

    test "create_document/3 with invalid data returns error changeset", %{
      project: project,
      user: user
    } do
      assert {:error, %Ecto.Changeset{}} = Editor.create_document(project, user, @invalid_attrs)
    end

    test "update_document/2 with valid data updates the document", %{document: document} do
      assert {:ok, document} = Editor.update_document(document, @update_attrs)
      assert %Document{} = document
      assert document.name == "Getting Started"
    end

    test "update_document/2 with invalid data returns error changeset", %{document: document} do
      assert {:error, %Ecto.Changeset{}} = Editor.update_document(document, @invalid_attrs)
      assert document == Editor.get_document!(document.id)
    end

    test "delete_document/1 deletes the document", %{document: document} do
      assert {:ok, %Document{}} = Editor.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Editor.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset", %{document: document} do
      assert %Ecto.Changeset{} = Editor.change_document(document)
    end
  end

  describe "lines" do
    alias Docdog.Editor.Line

    @update_attrs %{"translated_text" => "Эликсир"}

    setup do
      user = insert(:user)
      document = insert(:document, user: user)
      line = insert(:processed_line, document: document, user: user)

      {:ok, user: user, _line: line, document: document}
    end

    test "get_line/1 returns the line with given id", %{_line: line} do
      assert Editor.get_line!(line.id) == line
    end

    test "get_lines_for_document/1 returns lines for given document", %{
      document: document,
      _line: line
    } do
      assert Editor.get_lines_for_document(document) == [line]
    end

    test "update_line/3 with valid data updates the line", %{_line: line, user: user} do
      assert {:ok, line} = Editor.update_line(line, user, @update_attrs)
      assert %Line{} = line
      assert line.translated_text == "Эликсир"
    end

    test "change_line/1 returns a line changeset", %{_line: line} do
      assert %Ecto.Changeset{} = Editor.change_line(line)
    end
  end
end
