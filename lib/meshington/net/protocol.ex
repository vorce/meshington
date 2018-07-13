defmodule Meshington.Net.Protocol do
  @moduledoc """
  A simple TCP protocol handler that echoes all messages received.
  """
  use GenServer

  require Logger

  # State
  defstruct socket: nil,
            transport: nil,
            peer_name: ""

  # Client

  @doc """
  Starts the handler with `:proc_lib.spawn_link/3`.
  """
  def start_link(ref, socket, transport, _opts) do
    pid = :proc_lib.spawn_link(__MODULE__, :init, [ref, socket, transport])
    {:ok, pid}
  end

  def init(args) do
    {:ok, args}
  end

  @doc """
  Initiates the handler, acknowledging the connection was accepted.
  Finally it makes the existing process into a `:gen_server` process and
  enters the `:gen_server` receive loop with `:gen_server.enter_loop/3`.
  """
  def init(ref, socket, transport) do
    Logger.debug("init/3")
    peername = stringify_peername(socket)

    Logger.info(fn -> "Peer #{peername} connecting" end)

    :ok = :ranch.accept_ack(ref)
    :ok = transport.setopts(socket, [{:active, true}])

    :gen_server.enter_loop(__MODULE__, [], %__MODULE__{
      socket: socket,
      transport: transport,
      peer_name: peername
    })
  end

  # Server callbacks

  def handle_info({:tcp, _, message},
                  %__MODULE__{socket: _socket, transport: _transport, peer_name: peername} = state) do
    Logger.debug(fn ->
      "Received new message from peer #{peername}: #{inspect(message)}"
    end)

   with {:ok, db} <- Meshington.Parse.input(message),
        :ok <- Meshington.PeerSync.join(db) do
    Logger.debug(fn -> "Received valid state from peer #{peername}: merged it" end)
    Meshington.Vault.sync()
   else
    unexpected ->
      Logger.warn(fn ->
        "Received unknown message from peer #{peername}: #{inspect(unexpected)}. Ignoring it."
      end)
   end

   {:noreply, state}
  end

  # def handle_info(
  #       {:tcp, _, message},
  #       %__MODULE__{socket: socket, transport: transport, peer_name: peername} = state
  #     ) do
  #   Logger.warn(fn ->
  #     "Received unknown message format from peer #{peername}: #{inspect(message)}. Ignoring it."
  #   end)

  #   # Sends the message back
  #   transport.send(socket, message)

  #   {:noreply, state}
  # end

  def handle_info({:tcp_closed, _}, %__MODULE__{peer_name: peername} = state) do
    Logger.info(fn ->
      "Peer #{peername} disconnected"
    end)

    {:stop, :normal, state}
  end

  def handle_info({:tcp_error, _, reason}, %__MODULE__{peer_name: peername} = state) do
    Logger.error(fn -> "Error with peer #{peername}: #{inspect(reason)}" end)

    {:stop, :normal, state}
  end

  # Helpers

  defp stringify_peername(socket) do
    {:ok, {addr, port}} = :inet.peername(socket)

    address =
      addr
      |> :inet_parse.ntoa()
      |> to_string()

    "#{address}:#{port}"
  end
end
