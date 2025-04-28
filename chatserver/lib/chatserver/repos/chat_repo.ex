defmodule Chatserver.Repos.ChatRepo do
  import Ecto.Query, warn: false
  alias Chatserver.Repo
  alias Chatserver.Tables.Chat
  alias Chatserver.Tables.User
  alias Chatserver.Tables.ChatsUsers

  def list_chats do
    Repo.all(Chat)
  end

  def get_chat!(id) do
    Repo.get!(Chat, id)
  end

  def update_chat(%Chat{} = chat, attrs) do
    chat
    |> Chat.changeset(attrs)
    |> Repo.update()
  end

  def delete_chat(%Chat{} = chat) do
    Repo.delete(chat)
  end

  def change_chat(%Chat{} = chat, attrs) do
    Chat.changeset(chat, attrs)
  end

  def link_users_to_chat(chat, user_ids) do
    # Build the list of changesets for the chats_users join table
    chats_users_changesets =
      Enum.map(user_ids, fn user_id ->
        %Chatserver.Tables.ChatsUsers{}
        |> Chatserver.Tables.ChatsUsers.changeset(%{user_id: user_id, chat_id: chat.id})
      end)

    # Insert all the changesets into the database
    Repo.transaction(fn ->
      Enum.each(chats_users_changesets, fn changeset ->
        case Repo.insert(changeset) do
          {:ok, _} -> :ok
          {:error, reason} -> Repo.rollback(reason)
        end
      end)
    end)
  end

  def create_chat(title, usernames, is_group_chat \\ false) do
    # Находим пользователей по их именам
    user_ids =
      User
      |> where([u], u.username in ^usernames)
      |> select([u], u.id)
      |> Repo.all()

    # Если пользователи не найдены, возвращаем ошибку
    if Enum.empty?(user_ids) do
      {:error, :users_not_found}
    else
      # Создаем новый чат
      %Chat{}
      |> Chat.changeset(%{title: title, is_group_chat: is_group_chat})
      |> Repo.insert()
      |> case do
        {:ok, chat} ->
          # Связываем чат с пользователями
          case link_users_to_chat(chat, user_ids) do
            {:ok, _} -> {:ok, chat}
            {:error, reason} -> {:error, reason}
          end

        {:error, changeset} ->
          {:error, changeset}
      end
    end
  end

  def get_chats_by_usernames(usernames) when is_list(usernames) do
    # Находим ID пользователей по их именам
    user_ids =
      User
      |> where([u], u.username in ^usernames)
      |> select([u], u.id)
      |> Repo.all()

    # Если пользователи не найдены, возвращаем пустой список
    if Enum.empty?(user_ids) do
      []
    else
      # Находим чаты, в которых участвуют все указанные пользователи
      Chat
      |> join(:inner, [c], cu in "chats_users", on: c.id == cu.chat_id)
      |> where([_, cu], cu.user_id in ^user_ids)
      |> group_by([c], c.id)
      |> having([c, cu], count(cu.user_id) == ^length(user_ids))
      |> Repo.all()
    end
  end

  def get_dias_by_usernames(usernames) do
    Chatserver.Tables.Chat
    |> join(:inner, [c], cu in "chats_users", on: c.id == cu.chat_id)
    |> join(:inner, [c, cu], u in Chatserver.Tables.User, on: cu.user_id == u.id)
    |> where([c, cu, u], u.username in ^usernames)
    |> group_by([c], c.id)
    |> having([c, cu, u], count(u.id) == ^length(usernames))
    |> select([c], c)
    |> Repo.one()
  end

  def get_chats_by_username(username, limit \\ 10) do
    Chatserver.Tables.Chat
    |> join(:inner, [c], cu in "chats_users", on: c.id == cu.chat_id)
    |> join(:inner, [c, cu], u in Chatserver.Tables.User, on: cu.user_id == u.id)
    |> where([c, cu, u], u.username == ^username)
    |> order_by([c], desc: c.inserted_at) # Сортировка по убыванию даты создания
    |> limit(^limit)                     # Ограничение на количество результатов
    |> select([c], c)
    |> Repo.all()
  end

  def get_second_user_in_chat(chat_id, first_username) do
    Chatserver.Tables.User
    |> join(:inner, [u], cu in "chats_users", on: u.id == cu.user_id)
    |> join(:inner, [u, cu], c in Chatserver.Tables.Chat, on: cu.chat_id == c.id)
    |> where([u, cu, c], c.id == ^chat_id and c.is_group_chat == false)
    |> where([u, cu, c], u.username != ^first_username)
    |> Repo.one()
  end

end
