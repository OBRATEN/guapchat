defmodule Chatserver.Repo.Migrations.Default do
  use Ecto.Migration

  def change do
    create table("users") do
      add :username, :string
      add :password, :string, virtual: true
      add :password_hash, :string
      add :firstname, :string
      add :lastname, :string

      timestamps(type: :utc_datetime)
    end

    create table("dialogues") do
      add :user1_id, :integer
      add :user2_id, :integer

      timestamps(type: :utc_datetime)
    end

    create table("messages") do
      add :dialogue_id, :integer
      add :sender_id, :integer
      add :content, :string
      add :is_read, :boolean, default: false

      timestamps(type: :utc_datetime)
    end
  end
end
