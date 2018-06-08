defmodule EmbercatcherApiWeb.Router do
  use EmbercatcherApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EmbercatcherApiWeb do
    pipe_through :api
  end
end
