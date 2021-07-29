defmodule NetworkingLog.Repo.Migrations.AlterEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :note,      references(:notes)
    end
  end
end
