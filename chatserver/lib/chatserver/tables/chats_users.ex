defmodule Chatserver.Tables.ChatsUsers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats_users" do
    belongs_to :user, Chatserver.Tables.User
    belongs_to :chat, Chatserver.Tables.Chat
    timestamps()
  end

  def changeset(chat_user, attrs) do
    chat_user
    |> cast(attrs, [:user_id, :chat_id])
    |> validate_required([:user_id, :chat_id])
    |> unique_constraint([:user_id, :chat_id])
  end
end
