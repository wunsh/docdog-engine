defmodule Docdog.Editor.Services.CreateLines do
  @moduledoc """
    Service for lines creation
  """

  alias Docdog.Editor.Line
  alias Docdog.Editor.Services.{EncodeSnippet, DecodeSnippet}

  def call(nil, _) do
    []
  end

  def call(text, project_id) do
    text
    |> EncodeSnippet.call()
    |> String.split("\n")
    |> Enum.map(&DecodeSnippet.call/1)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.with_index()
    |> Enum.map(&Line.prepare_line/1)
    |> Enum.map(fn line -> Map.put(line, :project_id, project_id) end)
  end
end