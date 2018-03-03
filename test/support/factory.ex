defmodule Docdog.Factory do
  use ExMachina.Ecto, repo: Docdog.Repo

  def user_factory do
    %Docdog.Accounts.User{
      username: "ivan_ivanov",
      email: sequence(:email, &"ivanov-#{&1}@example.com"),
      avatar: "foo.bar"
    }
  end

  def project_factory do
    %Docdog.Editor.Project{
      name: "Elixir Documentation",
      public: false
    }
  end

  def with_documents(project) do
    insert(:document, project: project, user: build(:user), lines: [build(:processed_line)])
    project
  end

  def document_factory do
    %Docdog.Editor.Document{
      name: "Introduction",
      original_text: "Elixir is\nthe best language."
    }
  end

  def processed_line_factory do
    %Docdog.Editor.Line{
      original_text: "Elixir is",
      translated_text: "Эликсир - это",
      index_number: 1,
      processed: true
    }
  end

  def unprocessed_line_factory do
    %Docdog.Editor.Line{
      original_text: "the best language.",
      translated_text: nil,
      index_number: 2,
      processed: false
    }
  end
end
