defmodule Docdog.Editor.Policies.LinePolicy do
  @behaviour Bodyguard.Policy

  alias Docdog.Editor.Project
  alias Docdog.Editor.Document
  alias Docdog.Editor.Line
  alias Docdog.Accounts.User

  # Admin users can do anything
  def authorize(_, %User{admin: true}, _), do: true

  # Nobody can create new lines (it's automatically action)

  # Lines for documents in public projects

  # Project owners can read and update lines in public projects
  def authorize(action, _, %{
        line: %Line{project_id: project_id},
        project: %Project{id: project_id, public: true}
      })
      when action in [:read, :update],
      do: true

  # Only admin can delete documents from public projects

  # Lines for documents in private projects

  # Project participates can read and update lines in private projects
  def authorize(action, %User{id: user_id}, %{
        line: %Line{project_id: project_id},
        project: %Project{
          id: project_id,
          public: false,
          user_id: project_user_id,
          members: members
        }
      })
      when action in [:read, :update] do
    Enum.member?(members, user_id) || user_id == project_user_id
  end

  # Deny everything else
  def authorize(_, _, _), do: false
end
