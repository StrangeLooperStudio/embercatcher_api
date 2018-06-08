defmodule EmbercatcherApiWeb.UserController do
  use EmbercatcherApiWeb, :controller

  alias EmbercatcherApi.Account
  alias EmbercatcherApi.Account.User

  action_fallback EmbercatcherApiWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json-api", data: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, "show.json-api", data: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, "show.json-api", data: user)
    end
  end
end
