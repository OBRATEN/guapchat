defmodule Chatserver.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :sender_id, :integer
      add :receiver_id, :integer
      add :content, :string

      timestamps(type: :utc_datetime)
    end
  end
end
