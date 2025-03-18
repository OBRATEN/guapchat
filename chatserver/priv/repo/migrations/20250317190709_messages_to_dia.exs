defmodule Chatserver.Repo.Migrations.MessagesToDia do
  use Ecto.Migration

  def change do
    alert table(:messages) do
      remove :receiver_id
    end
  end
end
