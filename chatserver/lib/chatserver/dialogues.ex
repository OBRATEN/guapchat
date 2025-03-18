defmodule Chatserver.Dialogues do
  import Ecto.Query, warn: false
  alias Chatserver.Repo
  alias Chatserver.Dialogue.Dialogue

  def list_dialogues do
    Repo.all(Dialogue)
  end

  def get_dialogue!(id) do
    Repo.get!(Dialogue, id)
  end

  def create_dialogue(attrs \\ %{}) do
    changeset = %Dialogue{}
    |> Dialogue.changeset(attrs)
    case Repo.insert(changeset) do
      {:ok, dialogue} -> {:ok, dialogue}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def dialogue_exists?(user1_id, user2_id) do
    query =
      from d in Dialogue,
        where:
          (d.user1_id == ^user1_id and d.user2_id == ^user2_id) or
            (d.user1_id == ^user2_id and d.user2_id == ^user1_id),
        select: count(d.id)

    case Repo.one(query) do
      nil ->
        false

      0 ->
        false

      _ ->
        true
    end
  end

  def update_dialogue(%Dialogue{} = dialogue, attrs) do
    dialogue
    |> Dialogue.changeset(attrs)
    |> Repo.update()
  end

  def delete_dialogue(%Dialogue{} = dialogue) do
    Repo.delete(dialogue)
  end

  def change_dialogue(%Dialogue{} = dialogue, attrs) do
    Dialogue.changeset(dialogue, attrs)
  end
end
