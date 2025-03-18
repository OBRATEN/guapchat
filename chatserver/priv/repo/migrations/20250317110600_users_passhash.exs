defmodule Chatserver.Repo.Migrations.UsersPasshash do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :password, :string, virtual: true
      add :password_hash, :string
      add :firstname, :string
      add :lastname, :string

      timestamps(type: :utc_datetime)
    end
  end
end
