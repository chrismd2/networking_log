defmodule NetworkingLog.Nodes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  alias NetworkingLog.Nodes

  schema "notes" do
    field :text,              :string

    many_to_many :people,     Nodes.Person, join_through: "people"
    many_to_many :note,       Nodes.Note, join_through: "note"
    many_to_many :interests,  Nodes.Interest, join_through: "interests"
    many_to_many :places,     Nodes.Place, join_through: "places"
    many_to_many :groups,     Nodes.Group, join_through: "groups"
    many_to_many :events,     Nodes.Event, join_through: "events"

    timestamps()
  end

  def changeset(note, attrs) do
    note
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
