defmodule Chatserver.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password, :string
    field :firstname, :string
    field :lastname, :string
    field :is_online, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :firstname, :lastname, :is_online])
    |> validate_required([:username, :password, :firstname, :lastname, :is_online])
  end
end
