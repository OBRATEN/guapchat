defmodule ChatserverWeb.MainChannel do
  use ChatserverWeb, :channel
  alias Chatserver.Tables.Dialogue
  alias Chatserver.Tables.Message
  alias Chatserver.Repos.AccountRepo
  alias Chatserver.Repos.DialogueRepo
  alias Chatserver.Repos.MessageRepo
  alias Chatserver.Repos.ChatRepo

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
    case AccountRepo.get_similar_users(username) do
      nil ->
        push(socket, "SIMILAR_USERS_NOT_FOUND", %{timestamp: DateTime.utc_now()})
        {:noreply, socket}

      users ->
        usernames = Enum.map(users, fn user -> user.username end)
        push(socket, "SIMILAR_USERS", %{usernames: usernames})
        {:noreply, socket}
    end
  end

  def handle_in("new_dialogue", %{"username" => username}, socket) do
    current_username = socket.assigns.current_user.username

    case ChatRepo.get_dias_by_usernames([current_username, username]) do
      nil ->
        # No dialogue exists, create a new chat
        case ChatRepo.create_chat("DIALOGUE", [current_username, username]) do
          {:ok, chat} ->
            push(socket, "CREATED_DIALOGUE", %{
              timestamp: DateTime.utc_now(),
              chat_id: chat.id,
              username: username
            })
            {:noreply, socket}

          {:error, reason} ->
            push(socket, "ERROR CREATION DIALOGUE", %{
              timestamp: DateTime.utc_now(),
              message: inspect(reason)
            })
            {:noreply, socket}
        end

      chat ->
        # Dialogue already exists, use the retrieved chat
        push(socket, "DIALOGUE ALREADY EXISTS", %{
          timestamp: DateTime.utc_now(),
          chat_id: chat.id
        })
        {:noreply, socket}
    end
  end

  def handle_in("get_messages", %{"chat_id" => chat_id, "count" => count}, socket) do
    current_username = socket.assigns.current_user.username
    case MessageRepo.get_messages(chat_id, count) do
      nil ->
        push(socket, "GET_MESSAGES", %{timestamp: DateTime.utc_now(), message: "No messages yet", result: {}})
            {:noreply, socket}
      messages ->
        messages_to_json =
          Enum.map(messages, fn message ->
            content = message.content
            you_sent = message.sender_id. == socket.assigns.current_user.id
            is_read = message.is_read
            date = message.inserted_at
          end)
          json_messages = Jason.encode!(messages_to_json)

          push(socket, "GET_MESSAGES", %{timestamp: DateTime.utc_now(), message: "Got messages", result: json_messages})
            {:noreply, socket}
    end
  end


  def handle_in("get_chats", %{"count" => count}, socket) do
    current_username = socket.assigns.current_user.username
    case count > 0 do
      true ->
        case ChatRepo.get_chats_by_username(current_username, count) do
          [] ->
            push(socket, "DATA ERROR", %{timestamp: DateTime.utc_now()})
            {:noreply, socket}
          chats ->
            chats_for_json =
              Enum.map(chats, fn chat ->
                last_message = "No messages yet"
                last_message_date = ""
                case MessageRepo.get_last_message(chat.id) do
                  nil ->
                    last_message = "No messages yet"
                    last_message_date = ""
                  message ->
                    last_message = message.content
                    last_message_date = message.inserted_at
                end

                case chat.is_group_chat do
                  true ->
                    %{
                      id: Integer.to_string(chat.id),
                      title: chat.title,
                      last_message: last_message,
                      last_message_date: last_message_date
                    }
                  false ->
                    case ChatRepo.get_second_user_in_chat(chat.id, current_username) do
                      nil ->
                        push(socket, "DIA CONTENT ERROR", %{timestamp: DateTime.utc_now()})
                        {:noreply, socket}
                      user2 ->
                        %{
                          id: Integer.to_string(chat.id),
                          title: user2.username,
                          last_message: last_message,
                          last_message_date: last_message_date
                        }
                    end
                end
              end)

            json_dialogues = Jason.encode!(chats_for_json)

            push(socket, "CHATS_LIST_OK", %{
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
