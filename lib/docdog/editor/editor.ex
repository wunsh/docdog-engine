defmodule Docdog.Editor do
  @moduledoc """
  The Editor context.
  """

  import Ecto.Query

  alias Docdog.Repo
  alias Docdog.Editor.Project
  alias Docdog.Editor.Document
  alias Docdog.Editor.Line
  alias Docdog.Editor.Queries.ProjectQuery
  alias Docdog.Editor.Queries.DocumentQuery
  alias Docdog.Editor.Queries.LineQuery

  defdelegate authorize(action, user, params), to: Docdog.Editor.Policies.Router

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects() do
    Project
    |> ProjectQuery.default_scope()
    |> Repo.all()
  end

  def full_list_projects(user) do
    Project
    |> ProjectQuery.default_scope(user)
    |> ProjectQuery.with_completed_percentages()
    |> Repo.all()
  end

  def full_list_popular_projects do
    Project
    |> ProjectQuery.with_completed_percentages()
    |> ProjectQuery.popular_scope()
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
    Project
    |> ProjectQuery.default_scope()
    |> Repo.get!(id)
  end

  def get_project_by_invite_code!(invite_code) do
    Project
    |> ProjectQuery.default_scope()
    |> Repo.get_by!(invite_code: invite_code)
  end

  def all_members_for_project(project) do
    member_ids = project.members

    from(
      u in Docdog.Accounts.User,
      where: u.id in ^member_ids
    )
    |> Repo.all
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

  def add_member_to_project(%Project{} = project, new_member) do
    new_members_map = %{members: project.members ++ [new_member.id]}

    project
    |> Ecto.Changeset.change(new_members_map)
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

  @doc """
  Returns the list of documents.

  ## Examples

      iex> list_documents()
      [%Document{}, ...]

  """
  def list_documents do
    Document
    |> DocumentQuery.default_scope()
    |> Repo.all()
  end

  def list_documents_for_project(project_id) do
    Document
    |> DocumentQuery.default_scope()
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
  def get_document!(id) do
    Document
    |> DocumentQuery.default_scope()
    |> Repo.get!(id)
  end

  @doc """
  Creates a document.

  ## Examples

      iex> create_document(%{field: value})
      {:ok, %Document{}}

      iex> create_document(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_document(project, user, attrs \\ %{}) do
    attrs =
      attrs
      |> Map.put("user_id", user.id)
      |> Map.put("project_id", project.id)

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

  def get_line!(id) do
    Line
    |> LineQuery.default_scope()
    |> Repo.get!(id)
  end

  def get_lines_for_document(document) do
    Line
    |> LineQuery.default_scope()
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
