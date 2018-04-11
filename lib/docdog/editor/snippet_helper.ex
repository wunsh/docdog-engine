defmodule Docdog.Editor.SnippetHelper do
  @moduledoc """
    The snippet helper
  """

  def process_snippets(text) do
    snippets =
      ~r/```[^`]*```/
      |> Regex.scan(text)
      |> Enum.map(&hd/1)

    replacements = Enum.map(snippets, &encode_newlines/1)

    snippets
    |> Stream.zip(replacements)
    |> Enum.reduce(text, fn {from, to}, s ->
      String.replace(s, from, to)
    end)
  end

  def encode_newlines(string) do
    string
    |> String.replace(~r/\n/, "%$%n$%$")
  end

  def decode_newlines(string) do
    string
    |> String.replace("%$%n$%$", "\n")
  end
end
