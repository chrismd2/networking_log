defmodule NetworkingLog.Repo.Migrations.AddGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name,      :string
      add :phone,     :string, size: 10
      add :email,     :string
      add :website,   :string

      add :people,    references(:people)
      add :places,    references(:places)
      # add :interests, references(:interests)
      # add :events,    references(:events)
      # add :note,      references(:notes)

      timestamps()
    end
  end
end
