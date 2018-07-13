defmodule Meshington.SyncSecret do
  @moduledoc """
  Represent a secret that can be synced across the network
  """

  defstruct name: "",
            url: "",
            username: "",
            password: "",
            notes: ""

  def new(name, url, username, password, notes \\ "") do
    %__MODULE__{
      name: name,
      url: url,
      username: username,
      password: password,
      notes: notes
    }
  end

  def new(%Meshington.Vault.Secret{} = vaul_secret) do
    %__MODULE__{
      name: vaul_secret.name,
      url: vaul_secret.url,
      username: vaul_secret.username,
      password: vaul_secret.password,
      notes: vaul_secret.notes
    }
  end
end
