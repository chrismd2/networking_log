defmodule NetworkingLog.Repo.Migrations.AlterInterests do
  use Ecto.Migration

  def change do
    alter table(:interests) do
      add :events,    references(:events)
      add :note,      references(:notes)
    end
  end
end
