# lib/chat_app/auth.ex
defmodule Chatserver.Auth do
  alias Joken
  alias ChatserverWeb.Endpoint
  require Logger



  @doc """
  Validates a JWT and returns the user ID if valid.
  """
  def validate_token(token) do
    secret = Endpoint.config(:joken_secret)

    case Joken.decode(token, secret, ["HS256"]) do
      {:ok, claims} ->
        case Map.get(claims, "sub") do
          nil ->
            Logger.warn("Token is missing 'sub' claim")
            {:error, :missing_subject}

          sub_str ->
            case String.to_integer(sub_str) do
              nil ->
                Logger.warn("Token 'sub' claim is not a valid integer")
                {:error, :invalid_subject}

              user_id ->
                if expired?(claims) do
                  Logger.warn("Token has expired")
                  {:error, :token_expired}
                else
                  Logger.info("Token is valid for user #{user_id}")
                  {:ok, user_id}
                end
            end
        end

      {:error, reason} ->
        Logger.warn("Token is invalid: #{reason}")
        {:error, :invalid_token}
    end
  end

  defp expired?(claims) do
    exp = Map.get(claims, "exp")

    case exp do
      nil -> false # If no expiry, never expires!
      exp -> DateTime.utc_now() |> DateTime.to_unix > exp
    end
  end
end
