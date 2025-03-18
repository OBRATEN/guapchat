defmodule Chatserver.Dialogue.Dialogue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dialogues" do
    field :user1_id, :integer
    field :user2_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(dialogue, attrs) do
    dialogue
    |> cast(attrs, [:user1_id, :user2_id])
    |> validate_required([:user1_id, :user2_id])
  end
end
