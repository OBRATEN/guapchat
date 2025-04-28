defmodule Chatserver.Tables.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do
    field :title, :string
    field :is_group_chat, :boolean, default: false
    many_to_many :users, Chatserver.Tables.User, join_through: "chats_users"
    has_many :messages, Chatserver.Tables.Message
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:title, :is_group_chat])
    |> validate_required([:title])
  end
end
