defmodule Docdog.Editor.Policies.ProjectPolicy do
  @moduledoc """
  Defines project policies.
  """

  @behaviour Bodyguard.Policy

  alias Docdog.Editor.Project
  alias Docdog.Accounts.User

  @doc """
  Admin users can do anything.
  """
  def authorize(_, %User{admin: true}, _), do: true

  @doc """
  Regular users can create projects.
  """
  def authorize(:create, _, _), do: true

  @doc """
  Every authorized users instead of project author and members
  can accept invite to project.
  """
  def authorize(:accept_invite, %User{id: user_id}, %{
        project: %Project{user_id: project_author_id, members: members}
      }) do
    !(Enum.member?(members, user_id) || user_id == project_author_id)
  end

  # Public projects

  @doc """
  Regular users can read public projects.
  """
  def authorize(:read, _, %{project: %Project{public: true}}), do: true

  @doc """
  Project owners can update their own public projects.
  """
  def authorize(:update, %User{id: user_id}, %{
        project: %Project{user_id: user_id, public: true}
      }),
      do: true

  # Only admin can delete public projects

  # Private projects

  @doc """
  Only project members can read private projects.
  """
  def authorize(:read, %User{id: user_id}, %{
        project: %Project{
          public: false,
          user_id: project_user_id,
          members: members
        }
      }) do
    Enum.member?(members, user_id) || user_id == project_user_id
  end

  @doc """
  Project owners can update and delete their own private projects.
  """
  def authorize(action, %User{id: user_id}, %{
        project: %Project{user_id: user_id, public: false}
      })
      when action in [:update, :delete],
      do: true

  @doc """
  Deny everything else.
  """
  def authorize(_, _, _), do: false
end
