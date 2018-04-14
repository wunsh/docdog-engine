defmodule Docdog.Editor.Services.EncodeSnippet do
  @moduledoc """
    The snippet encoder
  """

  @snippet_regex ~r/```[^`]*```/
  @snippet_marker "%$%n$%$"

  def call(text) do
    snippets =
      @snippet_regex
      |> Regex.scan(text)
      |> Enum.map(&hd/1)

    replacements =
      snippets
      |> Enum.map(fn string ->
        String.replace(string, ~r/\n/, @snippet_marker)
      end)

    snippets
    |> Stream.zip(replacements)
    |> Enum.reduce(text, fn {from, to}, s ->
      String.replace(s, from, to)
    end)
  end
end
