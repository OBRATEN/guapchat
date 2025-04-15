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

  def handle_in("search_user", %{"username" => username}, socket) do
    case Accounts.get_similar_users(username) do
      nil ->
        push(socket, "SIMILAR_USERS_NOT_FOUND", %{timestamp: DateTime.utc_now()})
        {:noreply, socket}

      users ->
        usernames = Enum.map(users, fn user -> user.username end)
        push(socket, "SIMILAR_USERS", %{usernames: usernames})
        {:noreply, socket}
    end
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

  def handle_in("get_dialogues", %{"count" => count}, socket) do
    case count > 0 do
      true ->
        user1_id = socket.assigns.current_user.id

        case Dialogues.get_last_dialogues(count) do
          [] ->
            push(socket, "DATA ERROR", %{timestamp: DateTime.utc_now()})
            {:noreply, socket}

          dialogues ->
            dialogues_for_json =
              Enum.map(dialogues, fn dialogue ->
                last_message = "No messages yet"
                last_message_date = ""
                username2 = Accounts.get_user_by_id(dialogue.user2_id).username

                case Messages.last_message() do
                  nil ->
                    last_message = "No messages yet"

                  message ->
                    last_message = message.content
                    last_message_date = message.inserted_at
                end

                %{
                  id: dialogue.id,
                  user2_id: dialogue.user2_id,
                  username2: username2,
                  last_message: last_message,
                  last_message_date: last_message_date
                }
              end)

            json_dialogues = Jason.encode!(dialogues_for_json)

            push(socket, "GET_DIALOGUES_LIST", %{
              timestamp: DateTime.utc_now(),
              dialogues: json_dialogues
            })

            {:noreply, socket}
        end

      false ->
        push(socket, "DIA COUNT ERROR", %{timestamp: DateTime.utc_now()})
        {:noreply, socket}
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
