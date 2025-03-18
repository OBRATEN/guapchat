defmodule ChatserverWeb.DialogueController do
  use ChatserverWeb, :controller

  alias Chatserver.Dialogue
  alias Chatserver.Dialogue.Dialogue

  def new(conn, _params) do
    changeset = Dialogue.changeset(%Dialogue{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"dialogue" => dialogue_params}) do
    case Dialogue.create_dialogue(dialogue_params) do
      {:ok, dialogue} ->
        conn
        |> put_flash(:info, "Dialogue created successfully.")
        |> redirect(to: Routes.dialogue_path(conn, :show, dialogue)) # Assuming you have a show action
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    dialogue = Dialogue.get_dialogue!(id) # Or handle the case where the dialogue isn't found
    render(conn, :show, dialogue: dialogue)
  end
end
