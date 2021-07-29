defmodule NetworkingLog.Repo.Migrations.AlterGroups do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add :interests, references(:interests)
      add :events,    references(:events)
      add :notes,     references(:notes)
    end
  end
end
