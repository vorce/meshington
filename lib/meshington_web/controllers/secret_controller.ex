defmodule MeshingtonWeb.SecretController do
  use MeshingtonWeb, :controller

  alias Meshington.Vault
  alias Meshington.Vault.Secret

  def index(conn, _params) do
    secrets = Vault.list_secrets()
    render(conn, "index.html", secrets: secrets)
  end

  def new(conn, _params) do
    changeset = Vault.change_secret(%Secret{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"secret" => secret_params}) do
    with {:ok, secret} <- Vault.create_secret(secret_params) do
      conn
      |> put_flash(:info, "Secret #{secret.name} created successfully.")
      |> redirect(to: secret_path(conn, :show, secret))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    secret = Vault.get_secret!(id)
    render(conn, "show.html", secret: secret)
  end

  def edit(conn, %{"id" => id}) do
    secret = Vault.get_secret!(id)
    changeset = Vault.change_secret(secret)
    render(conn, "edit.html", secret: secret, changeset: changeset)
  end

  def update(conn, %{"id" => id, "secret" => secret_params}) do
    secret = Vault.get_secret!(id)

    case Vault.update_secret(secret, secret_params) do
      {:ok, secret} ->
        conn
        |> put_flash(:info, "Secret updated successfully.")
        |> redirect(to: secret_path(conn, :show, secret))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", secret: secret, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    secret = Vault.get_secret!(id)
    {:ok, _secret} = Vault.delete_secret(secret)

    conn
    |> put_flash(:info, "Secret deleted successfully.")
    |> redirect(to: secret_path(conn, :index))
  end
end
