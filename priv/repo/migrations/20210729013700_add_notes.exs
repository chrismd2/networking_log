defmodule NetworkingLog.Repo.Migrations.AddNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :text,      :string

      add :people,    references(:people)
      add :notes,     references(:notes)
      add :interests, references(:interests)
      add :places,    references(:places)
      add :groups,    references(:groups)
      add :events,    references(:events)

      timestamps()
    end
  end
end
