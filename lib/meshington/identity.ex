defmodule Meshington.Identity do
  @moduledoc """
  Identifies a meshington client/node.
  """
  defstruct name: "",
            uuid: ""

  def new(name) do
    %__MODULE__{
      name: name,
      uuid: mac_address()
    }
  end

  def mac_address() do
    with {:ok, addrs} <- :inet.getifaddrs() do
      addrs
      |> Enum.filter(fn {name, _} ->
        name == 'en0'
      end)
      |> List.first()
      |> elem(1)
      |> Keyword.get(:hwaddr, [])
      |> Enum.join()
    end
  end
end
