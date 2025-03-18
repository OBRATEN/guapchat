defmodule ChatserverWeb.UserSocket do
  use Phoenix.Socket
  alias Chatserver.Auth
  alias Chatserver.Accounts.User
  alias Chatserver.Accounts
  require Logger

  channel "chat_room:*", ChatserverWeb.ChatRoomChannel

  def connect(%{"token" => token}, socket) do
    case Auth.verify_token(token) do
      {:ok, payload} ->
        user_id = Map.get(payload, "user_id")
        Logger.info(user_id)

        case Accounts.get_user_by_id(user_id) do
          %User{} = user ->
            # Assign the user to the socket for later use in channels
            {:ok, assign(socket, :current_user, user)}

          nil ->
            {:error, :unauthorized} # User not found
        end

      {:error, _} ->
        {:error, :unauthorized} # Invalid token
    end
  end

  def connect(_params, _socket), do: {:error, :unauthorized}

  @impl true
  def id(_socket), do: nil
end
