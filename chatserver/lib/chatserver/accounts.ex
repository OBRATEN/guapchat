defmodule Chatserver.Accounts do
  alias Bcrypt, as: Bcrypt
  import Ecto.Query, warn: false
  alias Chatserver.Repo
  alias Chatserver.Accounts.User
  require Logger

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_id(id) do
    Repo.get(User, id)  # Assuming you have Repo defined.  Adjust as needed.
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    changeset = %User{}
      |> User.changeset(attrs)
      |> hash_password()
    case Repo.insert(changeset) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp hash_password(%{valid?: true, changes: %{password: password}} = changeset) do
     password_hash = Bcrypt.hash_pwd_salt(password)
     Ecto.Changeset.put_change(changeset, :password_hash, password_hash)
  end

  defp hash_password(changeset), do:  Ecto.Changeset.add_error(changeset, :password, "invalid password")


  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def authenticate_user(userid, password) do
    user = Repo.get_by(User, email: userid)

    case user do
      nil ->
        {:error, :invalid_credentials}

      user ->
        if Bycrypt.verify_pwd(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def check_password(username, password) do
    user = get_user_by_username(username)
    if Bcrypt.verify_pass(password, user.password_hash) do
      {:ok}
    else
      {:error}
    end
  end

  def get_user_id_by_username(username) do
    User
    |> where([u], u.username == ^username)
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      user -> {:ok, user.id}
    end
  end

  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end
end
