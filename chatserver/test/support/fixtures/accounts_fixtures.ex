defmodule Chatserver.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chatserver.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        firstname: "some firstname",
        is_online: true,
        lastname: "some lastname",
        password: "some password",
        username: "some username"
      })
      |> Chatserver.Accounts.create_user()

    user
  end
end
