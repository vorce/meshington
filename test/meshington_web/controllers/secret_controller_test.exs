defmodule MeshingtonWeb.SecretControllerTest do
  use MeshingtonWeb.ConnCase

  alias Meshington.Vault

  @create_attrs %{name: "some name", notes: "some notes", password: "some password", url: "some url", username: "some username"}
  @update_attrs %{name: "some updated name", notes: "some updated notes", password: "some updated password", url: "some updated url", username: "some updated username"}
  @invalid_attrs %{name: nil, notes: nil, password: nil, url: nil, username: nil}

  def fixture(:secret) do
    {:ok, secret} = Vault.create_secret(@create_attrs)
    secret
  end

  describe "index" do
    test "lists all secrets", %{conn: conn} do
      conn = get conn, secret_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Secrets"
    end
  end

  describe "new secret" do
    test "renders form", %{conn: conn} do
      conn = get conn, secret_path(conn, :new)
      assert html_response(conn, 200) =~ "New Secret"
    end
  end

  describe "create secret" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, secret_path(conn, :create), secret: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == secret_path(conn, :show, id)

      conn = get conn, secret_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Secret"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, secret_path(conn, :create), secret: @invalid_attrs
      assert html_response(conn, 200) =~ "New Secret"
    end
  end

  describe "edit secret" do
    setup [:create_secret]

    test "renders form for editing chosen secret", %{conn: conn, secret: secret} do
      conn = get conn, secret_path(conn, :edit, secret)
      assert html_response(conn, 200) =~ "Edit Secret"
    end
  end

  describe "update secret" do
    setup [:create_secret]

    test "redirects when data is valid", %{conn: conn, secret: secret} do
      conn = put conn, secret_path(conn, :update, secret), secret: @update_attrs
      assert redirected_to(conn) == secret_path(conn, :show, secret)

      conn = get conn, secret_path(conn, :show, secret)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, secret: secret} do
      conn = put conn, secret_path(conn, :update, secret), secret: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Secret"
    end
  end

  describe "delete secret" do
    setup [:create_secret]

    test "deletes chosen secret", %{conn: conn, secret: secret} do
      conn = delete conn, secret_path(conn, :delete, secret)
      assert redirected_to(conn) == secret_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, secret_path(conn, :show, secret)
      end
    end
  end

  defp create_secret(_) do
    secret = fixture(:secret)
    {:ok, secret: secret}
  end
end
