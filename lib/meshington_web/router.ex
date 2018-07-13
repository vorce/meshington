defmodule MeshingtonWeb.Router do
  use MeshingtonWeb, :router

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

  scope "/", MeshingtonWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/secrets", SecretController
  end

  # Other scopes may use custom stacks.
  # scope "/api", MeshingtonWeb do
  #   pipe_through :api
  # end
end
