defmodule EmbercatcherApiWeb.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :phoenix_blog_motor,
                              module: EmbercatcherApiWeb.Guardian,
                              error_handler: EmbercatcherApiWeb.Guardian.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
  plug :set_user

  def set_user(conn, _) do
    Plug.Conn.assign(conn, :user,  Guardian.Plug.current_resource(conn))
  end
end
