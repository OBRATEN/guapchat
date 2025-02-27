defmodule Chatserver.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chatserver.Messages` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content",
        receiver_id: 42,
        sender_id: 42
      })
      |> Chatserver.Messages.create_message()

    message
  end
end
