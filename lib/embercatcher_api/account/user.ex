defmodule EmbercatcherApi.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> put_password_hash
    |> downcase_email
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        change(changeset, %{
          encrypted_password: Comeonin.Argon2.hashpwsalt(pass),
          password: nil
        })
      _ ->
        changeset
    end
  end

  defp downcase_email(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp downcase_email(%Ecto.Changeset{valid?: true} = changeset) do
    if email = get_change(changeset, :email) do
      put_change(changeset, :email, String.downcase(email))
    else
      changeset
  end
end
end
