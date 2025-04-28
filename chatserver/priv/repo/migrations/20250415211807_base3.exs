defmodule Chatserver.Repo.Migrations.Base3 do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string)
      add(:password, :string, virtual: true)
      add(:password_hash, :string)
      add(:firstname, :string)
      add(:lastname, :string)
      timestamps()
    end

    create table(:dialogues) do
      add(:user1_id, :integer)
      add(:user2_id, :integer)
      timestamps(type: :utc_datetime)
    end

    create table(:chats) do
      add(:title, :string)
      add(:is_group_chat, :boolean, default: false)
      timestamps(type: :utc_datetime)
    end

    create table(:messages) do
      add(:chat_id, :integer)
      add(:sender_id, :integer)
      add(:content, :string)
      add(:is_read, :boolean, default: false)
      timestamps(type: :utc_datetime)
    end

    create table(:chats_users) do
      add(:user_id, references(:users, on_delete: :delete_all), null: false)
      add(:chat_id, references(:chats, on_delete: :delete_all), null: false)
      timestamps()
    end

    create(unique_index(:chats_users, [:user_id, :chat_id]))
  end
end
