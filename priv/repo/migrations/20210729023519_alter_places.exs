defmodule NetworkingLog.Repo.Migrations.AlterPlaces do
  use Ecto.Migration

  def change do
    alter table(:places) do
      add :groups,    references(:groups)
      add :interests, references(:interests)
      add :events,    references(:events)
      add :notes,      references(:notes)
    end
  end
end
