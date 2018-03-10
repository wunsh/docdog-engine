defmodule Docdog.Editor.Policies.Router do
  alias Docdog.Editor.Policies.ProjectPolicy
  alias Docdog.Editor.Policies.DocumentPolicy
  alias Docdog.Editor.Policies.LinePolicy

  def authorize(action, user, params) do
    {scope, real_action} = extract_scope(action)

    case scope do
      :project -> ProjectPolicy.authorize(real_action, user, params)
      :document -> DocumentPolicy.authorize(real_action, user, params)
      :line -> LinePolicy.authorize(real_action, user, params)
    end
  end

  defp extract_scope(action) do
    action
    |> to_string()
    |> String.split("_", parts: 2)
    |> Enum.map(&String.to_atom/1)
    |> List.to_tuple()
  end
end
