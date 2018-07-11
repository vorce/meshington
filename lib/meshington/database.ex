defmodule Meshington.Database do
  @moduledoc """
  Keeps local state in memory
  """
  alias Meshington.Identity
  alias Meshington.Secret

  alias Loom.AWORSet


  use GenServer

  defstruct secrets: AWORSet.new(),
            version: "v1"

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    {:ok, %__MODULE__{}}
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

  def remove(%Secret{} = secret) do
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

  defp add_to_secrets(%AWORSet{} = secrets, %Identity{} = id, %Secret{} = secret) do
    AWORSet.add(secrets, id, secret)
  end

  defp list_secrets(%AWORSet{} = secrets) do
    AWORSet.value(secrets)
  end

  defp join_secrets(%AWORSet{} = secrets1, %AWORSet{} = secrets2) do
    AWORSet.join(secrets1, secrets2)
  end
end
