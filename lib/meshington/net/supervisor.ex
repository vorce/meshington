defmodule Meshington.Net.Supervisor do
  @moduledoc """
  Supervisor for the Net subsystem which takes care of handling
  messages to/from peers.
  """

  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    server_config = Application.get_env(:meshington, Meshington.Net.Server)

    children = [
      {Meshington.Net.Server, server_config}
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.init(children, opts)
  end
end
