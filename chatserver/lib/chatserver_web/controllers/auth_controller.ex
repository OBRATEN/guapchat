defmodule ChatserverWeb.AuthController do
  use ChatserverWeb, :controller
  alias ElixirSense.Log
  alias Chatserver.Auth
  alias Chatserver.Accounts
  alias Chatserver.Accounts.User
  alias Bcrypt, as: Bcrypt
  require Logger

  @users %{"test" => "password"}

  def login(conn, %{"user" => user_params}) do
    username = Map.get(user_params, "username")
  password = Map.get(user_params, "password")
    IO.inspect(username, label: "username")

    case Accounts.get_user_by_username(username) do
      nil ->
        conn
        |> put_status(401)
        |> put_resp_header("content-type", "text/plain")
        |> send_resp(401, "Invalid credentials")
        |> halt()

      user ->
        case Accounts.check_password(username, password) do
          {:ok} ->
            claims = %{
              "user_id" => user.id
            }

            case Chatserver.Auth.generate_tokens(claims) do
              %{status: :ok, tokens: {access_token, refresh_token}} ->
                response = %{
                  "access_token" => access_token,
                  "refresh_token" => refresh_token,
                  "token_type" => "bearer",
                  "user" => %{
                    "id" => user.id,
                    "username" => user.username
                  }
                }
                conn
                |> put_status(200)
                |> put_resp_header("content-type", "application/json")
                |> send_resp(200, Jason.encode!(response))

              %{status: :error, error: reason} ->
                conn
                |> put_status(:internal_server_error)
                |> put_resp_header("content-type", "application/json")
                |> send_resp(500, Jason.encode!(%{errors: [reason]}))
            end

          {:error} ->
            conn
            |> put_status(401)
            |> put_resp_header("content-type", "text/plain")
            |> send_resp(401, "Wrong password")
            |> halt()
        end
    end
  end

  def register(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      user_id = Accounts.get_user_id_by_username(user.username) |> elem(1)

      claims = %{
        "user_id" => user_id
      }

      case Auth.generate_tokens(claims) do
        %{status: :ok, tokens: {access_token, refresh_token}} ->
          response = %{
            "access_token" => access_token,
            "refresh_token" => refresh_token,
            "token_type" => "bearer",
            "user" => %{
              "id" => user_id,
              "username" => user_params["username"]
            }
          }

          conn
          |> put_status(:ok)
          |> put_resp_header("content-type", "application/json")
          |> send_resp(200, Jason.encode!(response))

        %{status: :error, error: reason} ->
          conn
          |> put_status(:internal_server_error)
          |> put_resp_header("content-type", "application/json")
          |> send_resp(500, Jason.encode!(%{errors: [reason]}))
      end
    end
  end
end
