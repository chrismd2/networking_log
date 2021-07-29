defmodule NetworkingLog.Nodes.Place do
  use Ecto.Schema
  import Ecto.Changeset

  alias NetworkingLog.Nodes

  schema "places" do
    field :location,         :string
    field :name,             :string

    many_to_many :notes,     Nodes.Note, join_through: "note"
    many_to_many :interests, Nodes.Interest, join_through: "interests"
    many_to_many :people,    Nodes.Person, join_through: "people"
    many_to_many :groups,    Nodes.Group, join_through: "groups"
    many_to_many :events,    Nodes.Event, join_through: "events"

    timestamps()
  end

  def changeset(person, attrs) do
    person
    |> cast(attrs, [:location, :name])#, :notes, :interests, :people, :groups, :events])
    |> validate_required([:location, :name])
  end
end
