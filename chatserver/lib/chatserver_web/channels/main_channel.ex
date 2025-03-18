defmodule ChatserverWeb.MainChannel do
  use ChatserverWeb, :channel
  alias Chatserver.Dialogue.Dialogue
  alias Chatserver.Accounts
  alias Chatserver.Dialogues
  alias Chatserver.Messages
  alias Chatserver.Messages.Message

  def join("main", _params, socket) do
    case Phoenix.PubSub.subscribe(Chatserver.PubSub, "main:#{socket.assigns.current_user.id}") do
      :ok ->
        {:ok, socket}

      {:error, reason} ->
        # Log the error
        IO.warn("Failed to subscribe to pubsub: #{inspect(reason)}")
        # Or return some other error to the client
        {:error, :join_failed}
    end
  end

  def handle_in("ping", _payload, socket) do
    push(socket, "pong", %{timestamp: DateTime.utc_now()})
    {:noreply, socket}
  end

  # BODY: {"username"}
  def handle_in("new_dialogue", %{"username" => username}, socket) do
    user1_id = socket.assigns.current_user.id

    case Accounts.get_user_by_username(username) do
      nil ->
        push(socket, "NOT_CREATED", %{timestamp: DateTime.utc_now()})
        {:noreply, socket}

      user ->
        user2_id = user.id

        case Dialogues.dialogue_exists?(user1_id, user2_id) do
          true ->
            push(socket, "ALREADY EXISTS", %{timestamp: DateTime.utc_now()})
            {:noreply, socket}

          false ->
            with {:ok, %Dialogue{} = dialogue} <-
                   Dialogues.create_dialogue(%{"user1_id" => user1_id, "user2_id" => user2_id}) do
              push(socket, "CREATED", %{
                timestamp: DateTime.utc_now(),
                user1_id: user1_id,
                user2_id: user2_id,
                dialogue_id: dialogue.id
              })

              {:noreply, socket}
            end
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
