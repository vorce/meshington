defmodule Meshington.Repo.Migrations.CreateSecrets do
  use Ecto.Migration

  def change do
    create table(:secrets) do
      add :name, :string
      add :url, :string
      add :username, :string
      add :password, :string
      add :notes, :string

      timestamps()
    end

  end
end
