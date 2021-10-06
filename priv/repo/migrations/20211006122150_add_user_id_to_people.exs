defmodule NetworkingLog.Repo.Migrations.AddUserIdToPeople do
  use Ecto.Migration

  def change do
    alter table(:people) do
      add(:user_id, references(:users, on_delete: :delete_all) )
    end
  end
end
