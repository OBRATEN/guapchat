defmodule Chatserver.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string
      add :firstname, :string
      add :lastname, :string
      add :is_online, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
