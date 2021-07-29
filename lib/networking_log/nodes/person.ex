defmodule NetworkingLog.Nodes.Person do
  use Ecto.Schema
  import Ecto.Changeset

  alias NetworkingLog.Nodes

  schema "people" do
    field :name,              :string
    field :phone,             :string, size: 10
    field :email,             :string

    many_to_many :notes,      Nodes.Note, join_through: "notes"
    many_to_many :interests,  Nodes.Interest, join_through: "interests"
    many_to_many :places,     Nodes.Place, join_through: "places"
    many_to_many :groups,     Nodes.Group, join_through: "groups"
    many_to_many :events,     Nodes.Event, join_through: "events"

    timestamps()
  end

  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :phone, :email])#, :notes, :interests, :places, :groups, :events])
    |> validate_required([:name])
  end
end
