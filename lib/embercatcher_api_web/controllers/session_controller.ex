defmodule EmbercatcherApiWeb.SessionController do
  use EmbercatcherApiWeb, :controller

  alias EmbercatcherApi.Account
  alias EmbercatcherApi.Account.User

  action_fallback EmbercatcherApiWeb.FallbackController

  def create(conn, %{"session" => session_params}) do
    with %User{} = user <- Account.get_user_by_email!(session_params["email"]),
         { :ok } <- EmbercatcherApiWeb.Guardian.authenticate(%{user: user, password: session_params["password"]}) do

      conn = Guardian.Plug.sign_in(conn, EmbercatcherApiWeb.Guardian, user)

      render conn, "show.json-api", data: %{ token: Guardian.Plug.current_token(conn) }, user: user
    end
  end

  def show(conn, _params) do
    render conn, "show.json-api",  data: %{ id: 1, token: Guardian.Plug.current_token(conn)}
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn, EmbercatcherApiWeb.Guardian, [])
    send_resp(conn, :no_content, "")
  end
end
