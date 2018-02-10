defmodule Docdog.Editor do
  @moduledoc """
  The Editor context.
  """

  import Ecto.Query

  alias Docdog.Repo
  alias Docdog.Editor.Project
  alias Docdog.Editor.Document
  alias Docdog.Editor.Line

  def projects_query do
    Project
    |> preload([:user, documents: :user])
    |> order_by(desc: :inserted_at)
  end

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    projects_query
    |> Repo.all()
  end

  def full_list_projects do
    Project.with_completed_percentages_query()
    |> Repo.all()
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id) do
    projects_query
    |> Repo.get!(id)
  end

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(user, attrs \\ %{}) do
    attrs = attrs |> Map.put("user_id", user.id)

    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{source: %Project{}}

  """
  def change_project(%Project{} = project) do
    Project.changeset(project, %{})
  end

  def documents_query do
    Document
    |> preload([:user, :lines, project: :user])
    |> order_by(desc: :inserted_at)
  end

  @doc """
  Returns the list of documents.

  ## Examples

      iex> list_documents()
      [%Document{}, ...]

  """
  def list_documents do
    documents_query
    |> Repo.all()
  end

  def list_documents_for_project(project_id) do
    documents_query
    |> where(project_id: ^project_id)
    |> Repo.all()
  end

  @doc """
  Gets a single document.

  Raises `Ecto.NoResultsError` if the Document does not exist.

  ## Examples

      iex> get_document!(123)
      %Document{}

      iex> get_document!(456)
      ** (Ecto.NoResultsError)

  """
  def get_document!(id), do: documents_query |> Repo.get!(id)

  @doc """
  Creates a document.

  ## Examples

      iex> create_document(%{field: value})
      {:ok, %Document{}}

      iex> create_document(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_document(project, user, attrs \\ %{}) do
    attrs = attrs |> Map.put("user_id", user.id)

    project
    |> Ecto.build_assoc(:documents)
    |> Document.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a document.

  ## Examples

      iex> update_document(document, %{field: new_value})
      {:ok, %Document{}}

      iex> update_document(document, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_document(%Document{} = document, attrs) do
    document
    |> Document.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Document.

  ## Examples

      iex> delete_document(document)
      {:ok, %Document{}}

      iex> delete_document(document)
      {:error, %Ecto.Changeset{}}

  """
  def delete_document(%Document{} = document) do
    Repo.delete(document)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking document changes.

  ## Examples

      iex> change_document(document)
      %Ecto.Changeset{source: %Document{}}

  """
  def change_document(%Document{} = document) do
    Document.changeset(document, %{})
  end

  def line_query do
    Line
    |> preload([:user, document: :user])
    |> Line.default_scope()
  end

  def get_line!(id) do
    line_query
    |> Repo.get!(id)
  end

  def get_lines_for_document(document) do
    line_query
    |> where(document_id: ^document.id)
    |> Repo.all()
  end

  def update_line(%Line{} = line, user, attrs) do
    attrs = Map.put(attrs, "user_id", user.id)

    line
    |> change_line(attrs)
    |> Repo.update()
  end

  def change_line(line, attrs \\ %{}) do
    Line.changeset(line, attrs)
  end
end
