defmodule Meshington.Vault.Secret do
  use Ecto.Schema
  import Ecto.Changeset


  schema "secrets" do
    field :name, :string
    field :notes, :string
    field :password, :string
    field :url, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(secret, attrs) do
    secret
    |> cast(attrs, [:name, :url, :username, :password, :notes])
    |> validate_required([:name])
  end

  def new(%Meshington.SyncSecret{} = sync_secret) do
    %{
      name: sync_secret.name,
      username: sync_secret.username,
      password: sync_secret.password,
      url: sync_secret.url,
      notes: sync_secret.notes
    }
  end
end
