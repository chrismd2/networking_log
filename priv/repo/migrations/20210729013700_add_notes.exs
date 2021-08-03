defmodule NetworkingLog.Repo.Migrations.AddNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :text,      :string

      add :people,    references(:people)

      timestamps()
    end
  end
end
