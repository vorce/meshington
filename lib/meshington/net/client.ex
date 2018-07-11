defmodule Meshington.Net.Client do
  @moduledoc """
  Meshington peer client
  """
  alias Meshington.Identity
  alias Meshington.Secret

  defstruct socket: nil,
            host: "",
            port: 3511,
            uri: ""

  @doc """
  Example:

      {:ok, client} = Meshington.Net.Client.connect("localhost", 3511)
      Meshington.Net.Client.send_state(client, %{"anything" => "here"})
      Socket.Stream.recv(client.socket)
      Meshington.Net.Client.disconnect(client)

  """
  def connect(host, port) do
    with {:ok, socket} <- Socket.TCP.connect(host, port) do
      {:ok, %__MODULE__{
        socket: socket,
        host: host,
        port: port
      }}
    end
  end

  @doc """
    Connect with uri, ex: connect("tcp://localhost:3511")
  """
  def connect(uri) do
    with {:ok, socket} <- Socket.connect(uri) do
      {:ok, %__MODULE__{
        socket: socket,
        uri: uri
      }}
    end
  end

  def send_state(%__MODULE__{} = client, state) do
    serialized_state = :erlang.term_to_binary(state)
    Socket.Stream.send(client.socket, serialized_state)
  end

  def get_state(%__MODULE__{} = client, options \\ []) do
    opts = Keyword.merge(default_get_options(), options)
    with {:ok, binary} <- Socket.Stream.recv(client.socket, opts) do
      {:ok, :erlang.binary_to_term(binary)}
    end
  end

  def disconnect(%__MODULE__{} = client) do
    Socket.close(client.socket)
  end

  defp default_get_options() do
    [timeout: 5_000]
  end
end
