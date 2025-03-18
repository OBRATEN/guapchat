defmodule Chatserver.Auth do
  @moduledoc """
  Модуль для генерации и проверки Access и Refresh JWT токенов с использованием Joken.
  """

  require Logger

  @issuer "GuapChat"
  @secret "7ZE1WwGzTNGcAX5RG3SfGkTf2QT/mFUIuUzWyySXnyYJ0ypv0g3ySLJmLY3Iq96+"
  @access_lifetime 3600
  @refresh_lifetime 86400

  @access_signing_alg "HS256"  # Используйте HS256, RS256 или ES256 в зависимости от требований.
  @refresh_signing_alg "HS256" #  Для Refresh токенов можно использовать более стойкий алгоритм.

  def generate_access_token(payload, options \\ []) do
    expiration_time = DateTime.utc_now() |> DateTime.add(@access_lifetime, :second)
    claims =
      payload
      |> Map.put("iss", @issuer)
      |> Map.put("exp", expiration_time)

    joken_options = %{
      alg: @access_signing_alg,
      secret: @secret,
      iss: @issuer,
    }

    case Joken.generate_and_sign(joken_options, claims) do
      {:ok, token, claims} ->
        %{status: :ok, token: token}  # Return a map here
      {:error, reason} ->
        Logger.error("Ошибка при генерации токена: #{inspect(reason)}")
        %{status: :error, error: :token_generation_failed} # and here
      error ->
        Logger.error("Неизвестная ошибка при генерации токена: #{inspect(error)}")
        %{status: :error, error: :token_generation_failed} # and here
    end
  end

  def generate_refresh_token(payload, options \\ []) do
    expiration_time = DateTime.utc_now() |> DateTime.add(@refresh_lifetime, :second)
    claims =
      payload
      |> Map.put("iss", @issuer)
      |> Map.put("exp", expiration_time)

    joken_options = %{
      alg: @refresh_signing_alg,
      secret: @secret,
      iss: @issuer,
    }

    case Joken.generate_and_sign(joken_options, claims) do
      {:ok, token, claims} ->
        %{status: :ok, token: token}
      {:error, reason} ->
        Logger.error("Ошибка при генерации токена: #{inspect(reason)}")
        %{status: :error, error: :token_generation_failed} # Используем атом
      error ->
        Logger.error("Неизвестная ошибка при генерации токена: #{inspect(error)}")
        %{status: :error, error: :unknown_error} # Используем атом
    end
  end

  def verify_token(token) do
    joken_options = %{
      alg: @refresh_signing_alg,
      secret: @secret,
      iss: @issuer,
    }

    case Joken.verify_and_validate(joken_options, token) do
      {:ok, claims} ->
        {:ok, claims}

      {:error, reason} ->
        Logger.warn("Ошибка при верификации токена: #{inspect(reason)}")
        {:error, reason}
    end
  end

  def verify_access_token(token) do
    verify_token(token)
  end

  def verify_refresh_token(token) do
    joken_config =
      Joken.Config.new()
      |> Joken.Config.alg(@refresh_signing_alg, @secret)
      |> Joken.Config.iss(@issuer)

    case Joken.verify(token, joken_config) do
      {:ok, claims} ->
        {:ok, claims}

      {:error, reason} ->
        Logger.warn("Ошибка при верификации Refresh токена: #{inspect(reason)}")
        {:error, reason}
    end
  end

  def generate_tokens(claims) do
    case generate_access_token(claims) do
      %{status: :ok, token: access_token} ->
        refresh_payload = %{user_id: claims["user_id"]} #  Используем claims["user_id"], если user_id - это string
        case generate_refresh_token(refresh_payload) do
          %{status: :ok, token: refresh_token} ->
            %{status: :ok, tokens: {access_token, refresh_token}}
          %{status: :error, error: reason} ->
            %{status: :error, error: reason} #  передаем ошибку дальше
        end
      %{status: :error, error: reason} ->
        %{status: :error, error: reason} # передаем ошибку дальше
    end
  end

end
