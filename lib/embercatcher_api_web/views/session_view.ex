defmodule EmbercatcherApiWeb.SessionView do
  use EmbercatcherApiWeb, :view

  location "/api/session"

  attributes [:token]

  has_one :user, include: true, serializer: EmbercatcherApiWeb.UserView

  def user(_token, conn) do
    Guardian.Plug.current_resource(conn)
  end
end
