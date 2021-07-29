defmodule NetworkingLog.Repo.Migrations.AddPeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :name,      :string
      add :phone,     :string, size: 10
      add :email,     :string

      timestamps()
    end
  end
end
