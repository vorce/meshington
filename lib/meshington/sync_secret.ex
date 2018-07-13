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

  def new(%Meshington.Vault.Secret{} = vault_secret) do
    %__MODULE__{
      name: vault_secret.name,
      url: vault_secret.url,
      username: vault_secret.username,
      password: vault_secret.password,
      notes: vault_secret.notes
    }
  end
end
