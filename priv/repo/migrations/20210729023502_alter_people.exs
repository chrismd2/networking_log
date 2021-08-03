defmodule NetworkingLog.Repo.Migrations.AlterPeople do
  use Ecto.Migration

  def change do
    alter table(:people) do
      add :notes,      references(:notes)
    end
  end
end
