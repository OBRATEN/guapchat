defmodule Chatserver.Tables.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :firstname, :string
    field :lastname, :string
    many_to_many :chats, Chatserver.Tables.Chat, join_through: "chats_users"
    timestamps(type: :utc_datetime)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :firstname, :lastname])
    |> validate_required([:username, :password])
    |> validate_length(:password, min: 6)
    |> unique_constraint(:username)
  end
end
