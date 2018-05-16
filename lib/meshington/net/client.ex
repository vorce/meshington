defmodule Meshington.Net.Client do
  @moduledoc """
  Meshington peer client
  """

  defstruct socket: nil,
            host: "",
            port: 3511

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

  def send_state(%__MODULE__{} = client, state) do
    serialized_state = :erlang.term_to_binary(state)
    Socket.Stream.send(client.socket, serialized_state)
  end

  def disconnect(%__MODULE__{} = client) do
    Socket.close(client.socket)
  end
end
