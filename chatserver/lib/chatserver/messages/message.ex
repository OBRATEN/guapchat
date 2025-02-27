defmodule Chatserver.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :sender_id, :integer
    field :receiver_id, :integer
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:sender_id, :receiver_id, :content])
    |> validate_required([:sender_id, :receiver_id, :content])
  end
end
