defmodule Meshington.Net.Server do
  @moduledoc """
  A simple TCP server.

  See: https://opencode.space/implementing-a-peer-to-peer-network-in-elixir-part-1
  """

  use GenServer

  alias Meshington.Net.Protocol

  require Logger

  @doc """
  Starts the server.
  """
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @doc """
  Initiates the listener (pool of acceptors).
  """
  def init([port: port] = opts) do
    {:ok, pid} = :ranch.start_listener(__MODULE__, 10, :ranch_tcp, opts, Protocol, []) # ranch_ssl

    Logger.info(fn -> "Listening for Meshington peer connections on port #{port}" end)

    {:ok, pid}
  end
end
