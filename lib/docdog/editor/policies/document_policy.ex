defmodule Docdog.Editor.Policies.DocumentPolicy do
  @behaviour Bodyguard.Policy

  alias Docdog.Editor.Project
  alias Docdog.Editor.Document
  alias Docdog.Accounts.User

  # Admin users can do anything
  def authorize(_, %User{admin: true}, _), do: true

  # Documents in public projects

  # Project owners can create documents in public projects
  def authorize(:create, %User{id: user_id}, %{
        project: %Project{id: project_id, user_id: user_id, public: true}
      }),
      do: true

  # Regular users can read documents in public projects
  def authorize(:read, _, %{
        document: %Document{project_id: project_id},
        project: %Project{id: project_id, public: true}
      }),
      do: true

  # Project owners can update documents in public projects
  def authorize(:update, %User{id: user_id}, %{
        document: %Document{project_id: project_id},
        project: %Project{id: project_id, user_id: user_id, public: true}
      }),
      do: true

  # Only admin can delete documents from public projects

  # Documents in private projects

  # Project owners can create documents in private projects
  def authorize(:create, %User{id: user_id}, %{
        project: %Project{id: project_id, user_id: user_id, public: false}
      }),
      do: true

  # Only project members can read documents in private projects
  def authorize(:read, %User{id: user_id}, %{
        document: %Document{project_id: project_id},
        project: %Project{
          id: project_id,
          public: false,
          user_id: project_user_id,
          members: members
        }
      }) do
    Enum.member?(members, user_id) || user_id == project_user_id
  end

  # Project owners can update and delete documents in private projects
  def authorize(action, %User{id: user_id}, %{
        document: %Document{project_id: project_id},
        project: %Project{id: project_id, user_id: user_id, public: false}
      })
      when action in [:update, :delete],
      do: true

  # Deny everything else
  def authorize(_, _, _), do: false
end
