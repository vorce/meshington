defmodule Meshington.Vault do
  @moduledoc """
  The Vault context.
  """

  import Ecto.Query, warn: false
  alias Meshington.Repo
  alias Meshington.Truth
  alias Meshington.Vault.Secret

  require Logger

  @doc """
  Returns the list of secrets.

  ## Examples

      iex> list_secrets()
      [%Secret{}, ...]

  """
  def list_secrets do
    Repo.all(Secret)
    # |> IO.inspect(label: "stored secrets")
    # Truth.list()
    # |> Enum.map(fn sync_secret ->
    #   Secret.new(sync_secret, :struct)
    # end)
  end

  @doc """
  Gets a single secret.

  Raises `Ecto.NoResultsError` if the Secret does not exist.

  ## Examples

      iex> get_secret!(123)
      %Secret{}

      iex> get_secret!(456)
      ** (Ecto.NoResultsError)

  """
  def get_secret!(id) do
    Repo.get!(Secret, id)
    # Truth.list()
    # |> Enum.find(fn sync_secret ->
    #   sync_secret.name == id
    # end)
    # |> Secret.new(:struct)
  end

  def sync() do
    secrets = Truth.list()
    |> Enum.map(fn sync_secret ->
      Secret.new(sync_secret)
    end)

    Repo.transaction(fn ->
      with {removed, _} <- from(s in Secret, where: s.id >= 0) |> Repo.delete_all(),
           {inserted, _} <- Repo.insert_all(Secret, secrets) do
        Logger.info("Synced vault with truth, secrets: #{inserted} (before: #{removed})")
        :ok
      else
        unexpected ->
          Repo.rollback({:unexptected, unexpected})
      end
    end)
  end

  @doc """
  Creates a secret.

  ## Examples

      iex> create_secret(%{field: value})
      {:ok, %Secret{}}

      iex> create_secret(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_secret(attrs \\ %{}) do
    myid = Meshington.Identity.new("MyLocalNode123") # TODO this should be generated on startup and saved in db, with a UUID (adn a humanized version of that for display)
    Repo.transaction(fn ->
      with {:ok, secret} <- %Secret{} |> Secret.changeset(attrs) |> Repo.insert(),
           :ok <- Truth.add(myid, secret),
           :ok <- Truth.sync() do
        secret
      else
        {:error, %Ecto.Changeset{} = changeset_error} ->
          Repo.rollback(changeset_error)
        unexpected ->
          Repo.rollback({:peer_sync, unexpected})
      end
    end)
  end

  @doc """
  Updates a secret.

  ## Examples

      iex> update_secret(secret, %{field: new_value})
      {:ok, %Secret{}}

      iex> update_secret(secret, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_secret(%Secret{} = secret, attrs) do
    # TODO: Update Truth

    secret
    |> Secret.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Secret.

  ## Examples

      iex> delete_secret(secret)
      {:ok, %Secret{}}

      iex> delete_secret(secret)
      {:error, %Ecto.Changeset{}}

  """
  def delete_secret(%Secret{} = secret) do
    with :ok <- Truth.remove(secret) do
      Repo.delete(secret)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking secret changes.

  ## Examples

      iex> change_secret(secret)
      %Ecto.Changeset{source: %Secret{}}

  """
  def change_secret(%Secret{} = secret) do
    Secret.changeset(secret, %{})
  end
end
