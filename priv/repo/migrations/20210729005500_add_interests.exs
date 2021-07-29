defmodule NetworkingLog.Repo.Migrations.AddInterests do
  use Ecto.Migration

  def change do
    create table(:interests) do
      add :name,      :string

      add :people,    references(:people)
      add :places,    references(:places)
      add :groups,    references(:groups)
      # add :events,    references(:events)
      # add :note,      references(:notes)

      timestamps()
    end
  end
end
