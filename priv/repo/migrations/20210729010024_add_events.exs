defmodule NetworkingLog.Repo.Migrations.AddEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name,      :string
      add :date,      :string, size: 10
      add :time,      :string

      add :interests, references(:interests)
      add :places,    references(:places)
      add :groups,    references(:groups)
      add :people,    references(:people)
      # add :note,      references(:notes)

      timestamps()
    end
  end
end
