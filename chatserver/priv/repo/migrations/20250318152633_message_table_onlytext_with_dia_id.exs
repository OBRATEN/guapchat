defmodule Chatserver.Repo.Migrations.MessageTableOnlytextWithDiaId do
  use Ecto.Migration

  def change do
    create table("messages") do
      add :dialogue_id, :integer
      add :sender_id, :integer
      add :content, :string
      add :is_read, :boolean
      timestamps(type: :utc_datetime)
    end
  end
end
