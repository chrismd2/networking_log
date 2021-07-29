defmodule NetworkingLog.Repo.Migrations.AlterGroups do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add :interests, references(:interests)
      add :events,    references(:events)
      add :note,      references(:notes)
    end
  end
end
