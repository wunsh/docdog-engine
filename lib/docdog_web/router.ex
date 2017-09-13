defmodule DocdogWeb.Router do
  use DocdogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DocdogWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/projects", ProjectController do
      resources "/documents", DocumentController
    end
  end

  scope "/api", DocdogWeb do
    pipe_through :api

    resources "/lines", LineController, only: [:update]
  end

  # Other scopes may use custom stacks.
  # scope "/api", DocdogWeb do
  #   pipe_through :api
  # end
end
