defmodule NetworkingLog.Repo.Migrations.AlterNotes do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      add(:user_id, references(:users, on_delete: :delete_all) )
    end
  end
end
