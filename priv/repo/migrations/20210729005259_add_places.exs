defmodule NetworkingLog.Repo.Migrations.AddPlaces do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :location,  :string

      add :people,    references(:people)

      timestamps()
    end
  end
end
