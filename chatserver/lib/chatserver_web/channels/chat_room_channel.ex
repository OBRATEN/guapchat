defmodule ChatserverWeb.ChatRoomChannel do
  use ChatserverWeb, :channel

  @impl true
  def join("chat_room:" <> room_id, payload, socket) do
    IO.inspect(room_id, label: "Topic")
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    IO.puts "Received ping, sending pong"
    push(socket, "pong", %{timestamp: DateTime.utc_now()})
    {:noreply, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    user_id = socket.assigns.user_id
    message = %{user_id: user_id, body: body}
    Phoenix.PubSub.broadcast(ChatserverWeb.PubSub, "chat_room:#{room_id(socket)}", {:new_msg, message})
    IO.puts("Received message, sending to topic")
    IO.puts(body, user_id)
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat_room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp room_id(socket) do
    socket.topic |> String.split(":", parts_to_keep: :all) |> List.last()
  end
end
