defmodule NetworkingLog.Repo.Migrations.AlterInterests do
  use Ecto.Migration

  def change do
    alter table(:interests) do
      add :events,    references(:events)
      add :notes,      references(:notes)
    end
  end
end
