defmodule Chatserver.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :dialogue_id, :integer
    field :sender_id, :integer
    field :content, :string
    field :is_read, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:dialogue_id, :sender_id, :content])
    |> validate_required([:dialogue_id, :sender_id, :content])
  end
end
