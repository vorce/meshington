defmodule Meshington.VaultTest do
  use Meshington.DataCase

  alias Meshington.Vault

  # TODO: Clean up fixtures before each run... this is not supported out of the box with ecto_mnesia.

  describe "secrets" do
    alias Meshington.Vault.Secret

    @valid_attrs %{name: "some name", notes: "some notes", password: "some password", url: "some url", username: "some username"}
    @update_attrs %{name: "some updated name", notes: "some updated notes", password: "some updated password", url: "some updated url", username: "some updated username"}
    @invalid_attrs %{name: nil, notes: nil, password: nil, url: nil, username: nil}

    def secret_fixture(attrs \\ %{}) do
      {:ok, secret} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Vault.create_secret()

      secret
    end

    test "list_secrets/0 returns all secrets" do
      secret = secret_fixture()
      assert is_list(Vault.list_secrets())
    end

    test "get_secret!/1 returns the secret with given id" do
      secret = secret_fixture()
      assert Vault.get_secret!(secret.id) == secret
    end

    test "create_secret/1 with valid data creates a secret" do
      assert {:ok, %Secret{} = secret} = Vault.create_secret(@valid_attrs)
      assert secret.name == "some name"
      assert secret.notes == "some notes"
      assert secret.password == "some password"
      assert secret.url == "some url"
      assert secret.username == "some username"
    end

    test "create_secret/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vault.create_secret(@invalid_attrs)
    end

    test "update_secret/2 with valid data updates the secret" do
      secret = secret_fixture()
      assert {:ok, secret} = Vault.update_secret(secret, @update_attrs)
      assert %Secret{} = secret
      assert secret.name == "some updated name"
      assert secret.notes == "some updated notes"
      assert secret.password == "some updated password"
      assert secret.url == "some updated url"
      assert secret.username == "some updated username"
    end

    test "update_secret/2 with invalid data returns error changeset" do
      secret = secret_fixture()
      assert {:error, %Ecto.Changeset{}} = Vault.update_secret(secret, @invalid_attrs)
      assert secret == Vault.get_secret!(secret.id)
    end

    test "delete_secret/1 deletes the secret" do
      secret = secret_fixture()
      assert {:ok, %Secret{}} = Vault.delete_secret(secret)
      assert_raise Ecto.NoResultsError, fn -> Vault.get_secret!(secret.id) end
    end

    test "change_secret/1 returns a secret changeset" do
      secret = secret_fixture()
      assert %Ecto.Changeset{} = Vault.change_secret(secret)
    end
  end
end
