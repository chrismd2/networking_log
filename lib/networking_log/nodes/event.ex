defmodule NetworkingLog.Nodes.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias NetworkingLog.Nodes

  schema "people" do
    field :name,              :string
    field :date,              :string
    field :time,              :string

    many_to_many :interests,  Nodes.Interest, join_through: "interests"
    many_to_many :places,     Nodes.Place, join_through: "places"
    many_to_many :groups,     Nodes.Group, join_through: "groups"
    many_to_many :people,     Nodes.Person, join_through: "people"
    # many_to_many :note,       Nodes.Note, join_through: "note"

    timestamps()
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end