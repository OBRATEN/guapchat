defmodule Chatserver.Repo.Migrations.MessageReadDefaultFalse do
  use Ecto.Migration

  def change do
    alter table("messages") do
      modify :is_read, :boolean, default: false
    end
  end
end
