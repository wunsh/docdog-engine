defmodule Docdog.AccountsTest do
  use ExUnit.Case
  use Docdog.DataCase

  import Docdog.Factory

  alias Docdog.Accounts

  describe "users" do
    alias Docdog.Accounts.User

    @valid_attrs params_for(:user)
    @update_attrs params_for(:user, %{username: "alex_alexandrov"})
    @invalid_attrs %{username: nil}
    @create_attrs_from_github %{
      email: "petrov@example.com",
      nickname: "petr_petrov",
      name: "Petr Petroff",
      first_name: "Petr",
      last_name: "Petrov",
      image: ""
    }

    setup do
      user = insert(:user)

      {:ok, user: user}
    end

    test "list_users/0 returns all users", %{user: user} do
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id", %{user: user} do
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.username == "ivan_ivanov"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user", %{user: user} do
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.username == "alex_alexandrov"
    end

    test "update_user/2 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user", %{user: user} do
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset", %{user: user} do
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "find_or_create/1 returns existed user when found by nickname", %{user: user} do
      {:ok, found_user} =
        Accounts.find_or_create(%Ueberauth.Auth{info: %{nickname: "ivan_ivanov"}})

      assert user == found_user
    end

    test "find_or_create/1 returns just created user with usesrname from name", %{
      user: existed_user
    } do
      {:ok, new_user} = Accounts.find_or_create(%Ueberauth.Auth{info: @create_attrs_from_github})
      refute existed_user == new_user
      assert new_user.username == "Petr Petroff"
    end

    test "find_or_create/1 returns just created user when info with empty name", %{
      user: existed_user
    } do
      params_without_name = %{@create_attrs_from_github | name: nil}

      {:ok, new_user} = Accounts.find_or_create(%Ueberauth.Auth{info: params_without_name})
      refute existed_user == new_user
      assert new_user.username == "Petr Petrov"
    end

    test "find_or_create/1 returns just created user when no any names in info", %{
      user: existed_user
    } do
      params_without_any_names = %{
        @create_attrs_from_github
        | name: nil,
          first_name: nil,
          last_name: nil
      }

      {:ok, new_user} = Accounts.find_or_create(%Ueberauth.Auth{info: params_without_any_names})
      refute existed_user == new_user
      assert new_user.username == "petr_petrov"
    end
  end
end
