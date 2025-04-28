defmodule Chatserver.Repos.MessageRepo do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Chatserver.Repo

  alias Chatserver.Tables.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    changeset = %Message{}
    |> Message.changeset(attrs)
    case Repo.insert(changeset) do
      {:ok, message} -> {:ok, message}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  def last_message() do
    Repo.one(
      from m in Message,
        order_by: [desc: m.inserted_at],
        limit: 1
    )
  end

  def get_last_messages(count, chat_id) do
    Message
    |> where([m], m.chat_id == ^chat_id)
    |> order_by(desc: :inserted_at)
    |> limit(^count)
    |> Repo.all()
  end

  def get_last_message(chat_id) do
    Chatserver.Tables.Message
    |> where([m], m.chat_id == ^chat_id)
    |> order_by([m], desc: m.inserted_at) # Сортировка по убыванию даты создания
    |> limit(1)                          # Ограничение на одно сообщение
    |> Repo.one()                        # Возвращаем одно сообщение или nil
  end

  def get_messages(chat_id, count) do
    Chatserver.Tables.Message
    |> where([m], m.chat_id == ^chat_id)
    |> order_by([m], desc: m.inserted_at) # Сортировка по убыванию даты создания
    |> limit(^count)                          # Ограничение на одно сообщение
    |> Repo.all()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
