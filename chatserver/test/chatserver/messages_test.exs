defmodule Chatserver.MessagesTest do
  use Chatserver.DataCase

  alias Chatserver.Messages

  describe "messages" do
    alias Chatserver.Messages.Message

    import Chatserver.MessagesFixtures

    @invalid_attrs %{sender_id: nil, receiver_id: nil, content: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Messages.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{sender_id: 42, receiver_id: 42, content: "some content"}

      assert {:ok, %Message{} = message} = Messages.create_message(valid_attrs)
      assert message.sender_id == 42
      assert message.receiver_id == 42
      assert message.content == "some content"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{sender_id: 43, receiver_id: 43, content: "some updated content"}

      assert {:ok, %Message{} = message} = Messages.update_message(message, update_attrs)
      assert message.sender_id == 43
      assert message.receiver_id == 43
      assert message.content == "some updated content"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message, @invalid_attrs)
      assert message == Messages.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end
end
