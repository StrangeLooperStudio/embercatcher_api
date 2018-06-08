defmodule EmbercatcherApiWeb.UserView do
  use EmbercatcherApiWeb, :view

  location "/api/users/:id"

  attributes [:email]
end
