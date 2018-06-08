defmodule EmbercatcherApiWeb.Router do
  use EmbercatcherApiWeb, :router

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  pipeline :api_auth do
    plug EmbercatcherApiWeb.Guardian.AuthPipeline
  end

  scope "/api", EmbercatcherApiWeb do
    pipe_through :api
    resources "/session", SessionController, only: [:create], singleton: true
    resources "/users", UserController, only: [:create]
  end

  scope "/api", EmbercatcherApiWeb do
    pipe_through [:api, :api_auth]
    resources "/users", UserController, only: [:show, :update]
    resources "/session", SessionController, only: [:show, :delete], singleton: true
  end
end
