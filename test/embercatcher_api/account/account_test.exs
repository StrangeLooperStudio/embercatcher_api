defmodule EmbercatcherApi.AccountTest do
  use EmbercatcherApi.DataCase

  alias EmbercatcherApi.Account

  alias EmbercatcherApi.Account.User

  @valid_attrs %{email: "some email", password: "some password"}
  @update_attrs %{email: "some updated email", password: "some updated password"}
  @invalid_attrs %{email: nil, password: nil}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Account.create_user()

    user
  end

  describe "list_users/0" do
    test "returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end
  end

  describe "get_user!/1" do
    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end
  end

  describe "create_user/1" do
    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.email == @valid_attrs.email
      assert Comeonin.Argon2.checkpw(@valid_attrs.password, user.encrypted_password)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end
  end

  describe "update_user/2" do
    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Account.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert Comeonin.Argon2.checkpw(@update_attrs.password, user.encrypted_password)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end
  end

  describe "delete_user/1" do
    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end
  end

  describe "change_user/1" do
    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end
end
