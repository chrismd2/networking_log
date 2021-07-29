defmodule NetworkingLog.Nodes.Interest do
  use Ecto.Schema
  import Ecto.Changeset

  alias NetworkingLog.Nodes

  schema "interests" do
    field :name,              :string

    many_to_many :people,     Nodes.Person, join_through: "people"
    many_to_many :places,     Nodes.Place, join_through: "places"
    many_to_many :groups,     Nodes.Group, join_through: "groups"
    many_to_many :events,     Nodes.Event, join_through: "events"
    many_to_many :notes,      Nodes.Note, join_through: "notes"

    timestamps()
  end

  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name])#, :people, :places, :groups, :events, :notes])
    |> validate_required([:name])
  end
end
