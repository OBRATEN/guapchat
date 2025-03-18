defmodule ChatserverWeb.DialogueChannel do
  use ChatserverWeb, :channel
  alias Chatserver.Dialogue.Dialogue
  alias Chatserver.Accounts
  alias Chatserver.Dialogues
  alias Chatserver.Messages
  alias Chatserver.Messages.Message

  def join("dialogue:" <> room_id, payload, socket) do
    case Dialogues.get_dialogue!(room_id) do
      nil ->
        {:error, :join_failed}

      dialogue ->
        user_id = socket.assigns.current_user.id

        if dialogue.user1_id == user_id || dialogue.user2_id == user_id do
          case Phoenix.PubSub.subscribe(Chatserver.PubSub, "main:#{user_id}") do
            :ok ->
              {:ok, socket}

            {:error, reason} ->
              # Log the error
              IO.warn("Failed to subscribe to pubsub: #{inspect(reason)}")
              # Or return some other error to the client
              {:error, :join_failed}
          end
        else
          {:error, :join_failed}
        end
    end
  end

  # BODY: {"dialogue_id" => dialogue_id, "content" => content}
  def handle_in("new_message", %{"dialogue_id" => dialogue_id, "content" => content}, socket) do
    user_id = socket.assigns.current_user.id

    case Dialogues.get_dialogue!(dialogue_id) do
      nil ->
        push(socket, "NOT_CREATED", %{timestamp: DateTime.utc_now()})
        {:noreply, socket}

      dialogue ->
        with {:ok, %Message{} = message} <-
               Messages.create_message(%{
                 "dialogue_id" => dialogue_id,
                 "sender_id" => user_id,
                 "content" => content,
                 "is_read" => false
               }) do
          push(socket, "CREATED", %{
            timestamp: DateTime.utc_now(),
            dialogue_id: dialogue_id,
            sender_id: user_id,
            content: content
          })

          {:noreply, socket}
        end
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp room_id(socket) do
    socket.topic |> String.split(":", parts_to_keep: :all) |> List.last()
  end
end
