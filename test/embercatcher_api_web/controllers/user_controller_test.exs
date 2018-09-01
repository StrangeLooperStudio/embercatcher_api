defmodule EmbercatcherApiWeb.UserControllerTest do
  use EmbercatcherApiWeb.ConnCase

  alias EmbercatcherApi.Account
  alias EmbercatcherApi.Account.User
  alias EmbercatcherApiWeb.Guardian

  @create_attrs %{
    email: "test@test.com",
    password: "test"
  }
  @update_attrs %{
    email: "test2@test.com",
    password: "test"
  }
  @invalid_attrs %{
    email: ""
  }

  def fixture(:user) do
    {:ok, user} = Account.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    user = fixture(:user)
    {:ok, token, _} = Guardian.encode_and_sign(user, %{}, token_type: :access)
    conn = conn
    |> put_req_header("authorization", "bearer: " <> token)
    |> put_req_header("accept", "application/vnd.api+json")
    |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn2 = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn2, 201)["data"]

      {:ok, conn: conn3, user: _} = auth_headers(%{conn: conn})

      conn3 = get conn, user_path(conn3, :show, id)
      assert json_response(conn3, 200) == JaSerializer.format(EmbercatcherApiWeb.UserView, Account.get_user!(id))

    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:auth_headers]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn2 = put conn, user_path(conn, :update, user), user: @update_attrs
      assert json_response(conn2, 200) == JaSerializer.format(EmbercatcherApiWeb.UserView, Account.get_user!(id))

      conn3 = get conn, user_path(conn, :show, id)
      assert json_response(conn3, 200) == JaSerializer.format(EmbercatcherApiWeb.UserView, Account.get_user!(id))

    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp auth_headers(  %{conn: conn} ) do
    user = fixture(:user)
    {:ok, token, _} = Guardian.encode_and_sign(user, %{}, token_type: :access)
     conn = conn
      |> put_req_header("authorization", "bearer: " <> token)
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

     {:ok, conn: conn, user: user}
  end
end
