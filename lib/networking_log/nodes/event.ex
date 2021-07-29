defmodule NetworkingLog.Nodes.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias NetworkingLog.Nodes

  schema "people" do
    field :name,              :string
    field :date,              :string
    field :time,              :string

    belongs_to :location,     Nodes.Place

    many_to_many :interests,  Nodes.Interest, join_through: "interests"
    # many_to_many :places,     Nodes.Place, join_through: "places"
    many_to_many :groups,     Nodes.Group, join_through: "groups"
    many_to_many :people,     Nodes.Person, join_through: "people"
    many_to_many :notes,      Nodes.Note, join_through: "notes"

    timestamps()
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :date, :time, :location, :interests, :groups, :people, :notes])
    |> validate_required([:name, :location])
  end
end
