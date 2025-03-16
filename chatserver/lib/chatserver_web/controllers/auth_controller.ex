defmodule ChatserverWeb.AuthController do
  use ChatserverWeb, :controller
  alias Chatserver.Auth
  require Logger

  # In-memory storage for demonstration purposes ONLY
  @users %{"test" => "password"}

  def login(conn, %{"username" => username, "password" => password}) do
    case Map.get(@users, username) do
      nil ->
        conn
        |> send_resp(401, "Invalid credentials")
        |> halt()

      stored_password ->
        if stored_password == password do
          case Auth.generate_token(String.length(username)) do # Уникальный ID для демо
            {:ok, token} ->
              conn
              |> put_resp_content_type("application/json")
              |> send_resp(200, Jason.encode!(%{token: token}))

            {:error, _reason} ->
              conn
              |> send_resp(500, "Failed to generate token")
              |> halt()
          end
        else
          conn
          |> send_resp(401, "Invalid credentials")
          |> halt()
        end
    end
  end

  def register(conn, %{"username" => username, "password" => password}) do
    # In real app hash password
    case Map.has_key?(@users, username) do
      true ->
        conn
        |> send_resp(400, "User already exists")
        |> halt()
      false ->
        @users = Map.put(@users, username, password)

        case Auth.generate_token(String.length(username)) do # Уникальный ID для демо
          {:ok, token} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(201, Jason.encode!(%{token: token}))

          {:error, _reason} ->
            conn
            |> send_resp(500, "Failed to generate token")
            |> halt()
        end
    end
  end
end
