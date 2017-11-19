defmodule DocdogWeb.Router do
  use DocdogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Docdog.CurrentUserPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug Docdog.CurrentUserPlug
  end

  pipeline :workplace_layout do
    plug :put_layout, {DocdogWeb.LayoutView, :workplace}
  end

  pipeline :simple_layout do
    plug :put_layout, {DocdogWeb.LayoutView, :simple}
  end

  scope "/", DocdogWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/workplace", DocdogWeb do
    pipe_through [:browser, :workplace_layout]

    resources "/projects", ProjectController do
      resources "/documents", DocumentController
    end
  end

  scope "/", DocdogWeb do
    pipe_through [:browser, :simple_layout]

    resources "/users", UserController
  end

  scope "/api/v1", DocdogWeb do
    pipe_through :api

    resources "/lines", LineController, only: [:update]
  end

  scope "/auth", DocdogWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end
end
