defmodule NetworkingLog.Repo.Migrations.AddTablePeopleToNotes do
  use Ecto.Migration

  def change do
    create table(:person_to_notes, primary_key: false) do
      add(:note_id, references(:notes, on_delete: :delete_all), primary_key: true)
      add(:person_id, references(:people, on_delete: :delete_all), primary_key: true)

      # timestamps()
    end
  end
end
