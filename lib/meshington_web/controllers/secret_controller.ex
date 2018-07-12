defmodule MeshingtonWeb.SecretController do
  use MeshingtonWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", secrets: Meshington.Database.list())
  end

  def edit(conn, %{"id" => secret_name} = _params) do
    secret = Meshington.Database.list()
    |> Enum.filter(fn secret -> secret.name == secret_name end)
    |> List.first()
    |> IO.inspect(label: "selected secret to edit")

    render(conn, "edit.html", secret: secret)
  end

  def update(conn, %{"id" => secret_name} = _params) do
    secret = Meshington.Database.list()
    |> Enum.filter(fn secret -> secret.name == secret_name end)
    |> List.first()

    conn
    |> put_flash(:info, "Secret #{secret.name} updated successfully.")
    |> render(conn, "index.html", secrets: Meshington.Database.list())
  end

  def update(conn, params) do
    IO.inspect(binding(), label: "Got update without id")

    conn
    |> put_flash(:info, "Secret ??? updated successfully.")
    |> render(conn, "index.html", secrets: Meshington.Database.list())
  end

  def delete(conn, %{"id" => _secret_name}) do
    render(conn, "index.html", secrets: Meshington.Database.list())
  end
end
