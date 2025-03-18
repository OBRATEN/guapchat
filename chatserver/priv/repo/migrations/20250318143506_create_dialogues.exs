defmodule Chatserver.Repo.Migrations.CreateDialogues do
  use Ecto.Migration

  def change do
    create table(:dialogues) do
      add :user1_id, :integer
      add :user2_id, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
