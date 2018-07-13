defmodule Meshington.Truth do
  @moduledoc """
  """
  alias Meshington.Identity
  alias Meshington.Vault.Secret
  alias Meshington.SyncSecret
  alias Loom.AWORSet

  # import Ecto.Query

  require Logger

  use GenServer

  defstruct secrets: AWORSet.new(),
            version: "v1"

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    myid = Meshington.Identity.new("MyLocalNode123")

    secrets = Secret
    |> Meshington.Repo.all()
    |> Enum.reduce(AWORSet.new(), fn stored_secret, acc ->
      AWORSet.add(acc, myid, SyncSecret.new(stored_secret))
    end)

    {:ok, %__MODULE__{secrets: secrets}}
  end

  def list() do
    GenServer.call(__MODULE__, :list)
  end

  def add(%Identity{} = id, %Secret{} = secret) do
    GenServer.call(__MODULE__, {:add, id, secret})
  end

  def join(%__MODULE__{} = db) do
    GenServer.call(__MODULE__, {:join, db})
  end

  def remove(%Secret{} = _secret) do
    :ok
  end

  def sync() do
    GenServer.cast(__MODULE__, :sync)
  end

  def handle_call({:add, id, secret}, _from, %__MODULE__{} = state) do
    {:reply, :ok, %__MODULE__{state | secrets: add_to_secrets(state.secrets, id, secret)}}
  end

  def handle_call(:list, _from, %__MODULE__{} = state) do
    {:reply, list_secrets(state.secrets), state}
  end

  def handle_call({:join, db}, _from, %__MODULE__{} = state) do
    {:reply, :ok, %__MODULE__{state | secrets: join_secrets(state.secrets, db.secrets)}}
  end

  def handle_cast(:sync, %__MODULE__{} = state) do
    # Meshington.Net.Client.send_state(client, state)
    Logger.info("TODO: Send state here to peers")
    {:noreply, state}
  end

  defp add_to_secrets(%AWORSet{} = secrets, %Identity{} = id, %Secret{} = secret) do
    AWORSet.add(secrets, id, SyncSecret.new(secret))
  end

  defp list_secrets(%AWORSet{} = secrets) do
    AWORSet.value(secrets)
  end

  defp join_secrets(%AWORSet{} = secrets1, %AWORSet{} = secrets2) do
    AWORSet.join(secrets1, secrets2)
  end
end
