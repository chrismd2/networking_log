defmodule NetworkingLog.Nodes.PersonToNotes do
  use Ecto.Schema
  import Ecto.Changeset

  alias NetworkingLog.Nodes.Person
  alias NetworkingLog.Nodes.Notes

  @already_exists "ALREADY EXISTS"

  @primary_key false
  schema "person_to_notes" do
    # field :person_id, :integer
    # field :note_id, :integer
    belongs_to(:person, Person, primary_key: true)
    belongs_to(:note, Notes, primary_key: true)

    # timestamps()
  end
end
