defmodule Docdog.Editor.Services.DecodeSnippet do
  @moduledoc """
    The snippet decoder
  """

  @snippet_marker "%$%n$%$"

  def call(string) do
    String.replace(string, @snippet_marker, "\n")
  end
end
