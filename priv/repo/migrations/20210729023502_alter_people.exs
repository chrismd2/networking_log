defmodule NetworkingLog.Repo.Migrations.AlterPeople do
  use Ecto.Migration

  def change do
    alter table(:people) do
      add :places,    references(:places)
      add :groups,    references(:groups)
      add :interests, references(:interests)
      add :events,    references(:events)
      add :notes,      references(:notes)
    end
  end
end
