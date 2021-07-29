defmodule NetworkingLog.Nodes.Group do
  use Ecto.Schema
  import Ecto.Changeset

  alias NetworkingLog.Nodes

  schema "groups" do
    field :name,              :string
    field :phone,             :string, size: 10
    field :email,             :string
    field :website,           :string

    many_to_many :people,     Nodes.Person, join_through: "people"
    many_to_many :places,     Nodes.Place, join_through: "places"
    many_to_many :interests,  Nodes.Interest, join_through: "interests"
    many_to_many :events,     Nodes.Event, join_through: "events"
    many_to_many :note,       Nodes.Note, join_through: "note"

    timestamps()
  end

  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
