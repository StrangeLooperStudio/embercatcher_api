defmodule EmbercatcherApiWeb.SessionControllerTest do
  use EmbercatcherApiWeb.ConnCase

  alias EmbercatcherApi.Account
  alias EmbercatcherApiWeb.Guardian

  @create_attrs %{
    email: "test@test.com",
    password: "test"
  }

  @invalid_password %{
    email: "test@test.com",
    password: "wtf"
  }

  @invalid_user %{
    email: "foo@bar.com",
    password: "wtf"
  }

  def fixture(:user) do
    {:ok, user} = Account.create_user(@create_attrs)
    user
  end

  describe "create session" do
    test "renders session when user password is correct", %{conn: conn} do
      fixture(:user)
      conn2 = post conn, session_path(conn, :create), session: @create_attrs
      token = json_response(conn2, 200)["data"]["attributes"]["token"]
      assert token == Guardian.Plug.current_token(conn2)
    end

    test "renders errors when password is incorrect", %{conn: conn} do
      fixture(:user)
      conn2 = post conn, session_path(conn, :create), session: @invalid_password
      assert json_response(conn2, 401)
    end

    test "renders errors when user is not found", %{conn: conn} do
      fixture(:user)
      conn2 = post conn, session_path(conn, :create), session: @invalid_user
      assert json_response(conn2, 401)
    end
  end

  describe "show session when logged in" do
    setup [:auth_headers]

    test "shows current session", %{conn: conn} do
      conn = get conn, session_path(conn, :show)
      assert json_response(conn, 200)["data"]["attributes"]["token"] == Guardian.Plug.current_token(conn)
    end
  end

  describe "show error for session when not logged in" do
    test "shows error", %{conn: conn} do
      conn = get conn, session_path(conn, :show)
      assert response(conn, 401)
    end
  end

  describe "delete session" do
    setup [:auth_headers]

    test "revokes current token", %{conn: conn} do
      conn2 = delete conn, session_path(conn, :delete)
      assert response(conn2, 204)
      conn3 = get conn2, session_path(conn, :show)
      assert response(conn3, 401)
    end
  end

  setup %{conn: conn} do
    conn = conn
    |> put_req_header("accept", "application/vnd.api+json")
    |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp auth_headers(  %{conn: conn} ) do
    user = fixture(:user)
    {:ok, token, _} = Guardian.encode_and_sign(user, %{}, token_type: :access)
     conn = conn
      |> put_req_header("authorization", "bearer: " <> token)
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

     {:ok, conn: conn}
  end
end
