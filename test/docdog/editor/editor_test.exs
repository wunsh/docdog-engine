# TODO: Fix tests

defmodule Docdog.EditorTest do
  use Docdog.DataCase

  alias Docdog.Editor

  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Editor.create_project()

    project
  end

  def document_fixture(attrs \\ %{}) do

    params = Enum.into(attrs, @valid_attrs)
    {:ok, document} = Editor.create_document(project_fixture, params)

    document
  end

  describe "projects" do
    alias Docdog.Editor.Project

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}



    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Editor.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Editor.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      assert {:ok, %Project{} = project} = Editor.create_project(@valid_attrs)
      assert project.name == "some name"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Editor.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      assert {:ok, project} = Editor.update_project(project, @update_attrs)
      assert %Project{} = project
      assert project.name == "some updated name"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Editor.update_project(project, @invalid_attrs)
      assert project == Editor.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Editor.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Editor.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Editor.change_project(project)
    end
  end

  describe "documents" do
    alias Docdog.Editor.Document

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_documents/0 returns all documents" do
      document = document_fixture()
      assert Editor.list_documents() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Editor.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      assert {:ok, %Document{} = document} = Editor.create_document(@valid_attrs)
      assert document.name == "some name"
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Editor.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()
      assert {:ok, document} = Editor.update_document(document, @update_attrs)
      assert %Document{} = document
      assert document.name == "some updated name"
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = Editor.update_document(document, @invalid_attrs)
      assert document == Editor.get_document!(document.id)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = Editor.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Editor.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = Editor.change_document(document)
    end
  end
end
