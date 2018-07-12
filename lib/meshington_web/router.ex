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

    resources("/secrets", SecretController)

    # get "/", SecretController, :index
    # get "/secrets/:secret_name", SecretController, :edit
    # put "/secrets/:secret_name", SecretController, :update
    # delete "/secrets/:secret_name", SecretController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", MeshingtonWeb do
  #   pipe_through :api
  # end
end
