defmodule ChatserverWeb.ChatRoomChannel do
  use ChatserverWeb, :channel

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

  def handle_in("ping", payload, socket) do

  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp room_id(socket) do
    socket.topic |> String.split(":", parts_to_keep: :all) |> List.last()
  end
end
